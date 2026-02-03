import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/recall_result_model.dart';
import '../../domain/models/trace_graph_model.dart';
import '../../domain/models/trace_node_model.dart';
import '../../domain/services/recall_severity_service.dart';
import '../cubit/traceability_cubit.dart';
import '../cubit/traceability_state.dart';
import '../projections/recall_severity_ui.dart';
import '../widgets/recall_confirmation_dialog.dart';
import '../widgets/recall_empty_state.dart';
import '../widgets/recall_radar.dart';
import '../widgets/recall_timeline.dart';

class TraceabilityViewBody extends StatelessWidget {
  final TraceabilityState state;
  final String rootNodeId;

  /// callback injected from TraceabilityView (logic preserved)
  final void Function(RecallResultModel recallResult) onConfirmRecall;

  const TraceabilityViewBody({
    super.key,
    required this.state,
    required this.rootNodeId,
    required this.onConfirmRecall,
  });

  @override
  Widget build(BuildContext context) {
    if (state is TraceabilityLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Graph mode
    if (state is TraceabilityGraphLoaded) {
      final graph = (state as TraceabilityGraphLoaded).graph;
      return TraceabilityGraphExplorer(graph: graph);
    }

    // Recall analysis mode
    if (state is TraceabilityRecallReady) {
      final recallState = state as TraceabilityRecallReady;
      final domainResult = recallState.projection.domainResult;

      final severityUi = RecallSeverityUI(recallState.severity);

      return Column(
        children: [
          // Executive severity header
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: _SeverityBanner(
              label: severityUi.label,
              color: severityUi.color,
              icon: severityUi.icon,
              affectedCount: domainResult.affectedNodes.length,
            ),
          ),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              children: [
                RecallRadar(projection: recallState.projection),
                const SizedBox(height: 12),
                _ExecutiveSectionTitle(
                  title: "Timeline",
                  subtitle:
                      "Responsibility chain and affected nodes (ordered by depth).",
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 420,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: RecallTimeline(projection: recallState.projection),
                  ),
                ),
              ],
            ),
          ),

          // Executive sticky action
          SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: severityUi.color.withOpacity(0.90),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => RecallConfirmationDialog(
                      affectedCount: domainResult.affectedNodes.length,
                      maxDepth: domainResult.maxDepth,
                      severity: severityUi,
                      onConfirm: () {
                        Navigator.pop(context);
                        onConfirmRecall(domainResult);
                      },
                    ),
                  );
                },
                child: const Text(
                  'Execute Recall',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const RecallEmptyState();
  }
}

/// ============================================================
/// GRAPH EXPLORER (Executive UI)
/// ============================================================

class TraceabilityGraphExplorer extends StatefulWidget {
  final TraceGraphModel graph;

  const TraceabilityGraphExplorer({super.key, required this.graph});

  @override
  State<TraceabilityGraphExplorer> createState() =>
      _TraceabilityGraphExplorerState();
}

class _TraceabilityGraphExplorerState extends State<TraceabilityGraphExplorer> {
  String? _selectedNodeId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final graph = widget.graph;

    final paths = graph.buildPathsFrom(graph.rootNodeId);

    final nodeIds = graph.nodes.keys.toList()
      ..sort((a, b) {
        final da = graph.depthOf(a, paths);
        final db = graph.depthOf(b, paths);
        if (da != db) return da.compareTo(db);
        final la = graph.nodes[a]?.label ?? a;
        final lb = graph.nodes[b]?.label ?? b;
        return la.compareTo(lb);
      });

    final rootNode = graph.nodes[graph.rootNodeId];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          child: _GraphHeaderCard(
            title: rootNode?.label ?? 'Batch',
            subtitle:
                'Nodes: ${graph.nodes.length} • Links: ${graph.edges.length}',
            onAnalyze: () {
              context.read<TraceabilityCubit>().analyzeRecall(graph.rootNodeId);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            itemCount: nodeIds.length,
            itemBuilder: (context, index) {
              final id = nodeIds[index];
              final node = graph.nodes[id];
              final depth = graph.depthOf(id, paths);

              return _ExecNodeCard(
                node: node,
                id: id,
                depth: depth,
                isSelected: _selectedNodeId == id,
                onTap: () {
                  setState(() => _selectedNodeId = id);
                  _openNodeSheet(context, node, id);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _openNodeSheet(BuildContext context, TraceNodeModel? node, String id) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final label = node?.label ?? id;
    final type = node?.type ?? 'unknown';
    final status = node?.status ?? 'unknown';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 12 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: scheme.surface.withOpacity(0.98),
                border: Border.all(color: Colors.black.withOpacity(0.06)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 30,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Pill(text: 'Type: $type'),
                        _Pill(text: 'Status: $status'),
                        if (node != null)
                          _Pill(text: 'Created: ${_fmt(node.createdAt)}'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: scheme.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: scheme.primary.withOpacity(0.14),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lightbulb_rounded,
                            color: scheme.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Analyze recall impact from this node to see affected batches and responsibility chain.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<TraceabilityCubit>().analyzeRecall(id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: scheme.primary.withOpacity(0.90),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.auto_graph_rounded),
                        label: const Text(
                          'Analyze',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _fmt(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}  ${two(d.hour)}:${two(d.minute)}';
  }
}

/// ============================================================
/// UI PARTS
/// ============================================================

class _GraphHeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onAnalyze;

  const _GraphHeaderCard({
    required this.title,
    required this.subtitle,
    required this.onAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: _execCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
            ),
            child: Icon(
              Icons.account_tree_rounded,
              color: scheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface.withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          TextButton.icon(
            onPressed: onAnalyze,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              backgroundColor: scheme.primary.withOpacity(0.08),
              foregroundColor: scheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
                side: BorderSide(color: scheme.primary.withOpacity(0.16)),
              ),
            ),
            icon: const Icon(Icons.warning_amber_rounded, size: 18),
            label: const Text(
              'Analyze',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExecNodeCard extends StatelessWidget {
  final TraceNodeModel? node;
  final String id;
  final int depth;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExecNodeCard({
    required this.node,
    required this.id,
    required this.depth,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final label = node?.label ?? id;
    final type = node?.type ?? 'unknown';
    final status = node?.status ?? 'unknown';

    final statusColor = _statusColor(scheme, status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white.withOpacity(0.92),
          border: Border.all(
            color: isSelected
                ? scheme.primary.withOpacity(0.22)
                : Colors.black.withOpacity(0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '$depth',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: scheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Pill(text: type),
                      _Pill(text: status, tint: statusColor),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.chevron_right_rounded,
              color: scheme.onSurface.withOpacity(0.55),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(ColorScheme scheme, String status) {
    final s = status.toLowerCase();
    if (s.contains('pass') || s.contains('approved'))
      return const Color(0xFF2E8B57);
    if (s.contains('fail') || s.contains('rejected'))
      return const Color(0xFFB00020);
    if (s.contains('block') || s.contains('archiv'))
      return scheme.onSurface.withOpacity(0.55);
    if (s.contains('risk') || s.contains('warn'))
      return const Color(0xFFFF8F00);
    return scheme.primary;
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color? tint;

  const _Pill({required this.text, this.tint});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = tint ?? scheme.onSurface.withOpacity(0.65);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: c.withOpacity(0.10),
        border: Border.all(color: c.withOpacity(0.16)),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: c),
      ),
    );
  }
}

class _ExecutiveSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ExecutiveSectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: t.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: t.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black54,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _SeverityBanner extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final int affectedCount;

  const _SeverityBanner({
    required this.label,
    required this.color,
    required this.icon,
    required this.affectedCount,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: color.withOpacity(0.10),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
          const Spacer(),
          Text(
            '$affectedCount nodes affected',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface.withOpacity(0.70),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _execCardDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(22),
    color: Colors.white.withOpacity(0.96),
    border: Border.all(color: Colors.black.withOpacity(0.05)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 26,
        offset: const Offset(0, 16),
      ),
    ],
  );
}
