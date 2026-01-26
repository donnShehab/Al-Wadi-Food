// // presentation/views/traceability_view_body.dart

// import 'package:flutter/material.dart';

// import '../../domain/models/recall_result_model.dart';
// import '../../domain/services/recall_severity_service.dart';
// import '../cubit/traceability_state.dart';
// import '../projections/recall_severity_ui_model.dart';
// import '../widgets/recall_empty_state.dart';
// import '../widgets/recall_radar.dart';
// import '../widgets/recall_timeline.dart';

// class TraceabilityViewBody extends StatelessWidget {
//   final TraceabilityState state;
//   final String rootNodeId;

//   /// 🔑 NEW: callback injected from TraceabilityView
//   final void Function(RecallResultModel recallResult) onConfirmRecall;

//   const TraceabilityViewBody({
//     super.key,
//     required this.state,
//     required this.rootNodeId,
//     required this.onConfirmRecall,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (state is TraceabilityLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (state is TraceabilityRecallReady) {
//       final recallState = state as TraceabilityRecallReady;
//       final domainResult = recallState.projection.domainResult;

//       /// 🔥 Severity (domain-backed)
//       final severity = RecallSeverityService.evaluate(domainResult);
//       final severityUi = RecallSeverityUiModel.fromSeverity(severity);

//       return Column(
//         children: [
//           // ============================================================
//           // 🚨 SEVERITY HEADER
//           // ============================================================
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             margin: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: severityUi.color.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.warning, color: severityUi.color),
//                 const SizedBox(width: 8),
//                 Text(
//                   severityUi.label,
//                   style: TextStyle(
//                     color: severityUi.color,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const Spacer(),
//                 Text(
//                   '${domainResult.affectedNodes.length} nodes affected',
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ],
//             ),
//           ),

//           // ============================================================
//           // 📡 VISUALIZATIONS
//           // ============================================================
//           Expanded(
//             flex: 2,
//             child: RecallRadar(projection: recallState.projection),
//           ),
//           Expanded(
//             flex: 3,
//             child: RecallTimeline(projection: recallState.projection),
//           ),

//           // ============================================================
//           // 🔐 ACTION PANEL — CONFIRMATION
//           // ============================================================
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: severityUi.color,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (_) => AlertDialog(
//                       title: const Text('Confirm Recall Execution'),
//                       content: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             severityUi.label,
//                             style: TextStyle(
//                               color: severityUi.color,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             'Affected Nodes: ${domainResult.affectedNodes.length}',
//                           ),
//                           Text(
//                             'Maximum Trace Depth: ${domainResult.maxDepth}',
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             'This action will BLOCK all affected nodes '
//                             'and create an immutable audit record.\n\n'
//                             'Do you want to proceed?',
//                           ),
//                         ],
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text('Cancel'),
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: severityUi.color,
//                           ),
//                           onPressed: () {
//                             Navigator.pop(context);

//                             /// 🔥 Delegate execution to View
//                             onConfirmRecall(domainResult);
//                           },
//                           child: const Text('Confirm & Execute'),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//                 child: const Text(
//                   'Execute Recall',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     return const RecallEmptyState();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/traceability_cubit.dart';
import '../../domain/models/trace_graph_model.dart';
import '../../domain/models/trace_node_model.dart';

import '../../domain/models/recall_result_model.dart';
import '../../domain/services/recall_severity_service.dart';
import '../cubit/traceability_state.dart';
import '../projections/recall_severity_ui_model.dart';
import '../widgets/recall_empty_state.dart';
import '../widgets/recall_radar.dart';
import '../widgets/recall_timeline.dart';

class TraceabilityViewBody extends StatelessWidget {
  final TraceabilityState state;
  final String rootNodeId;

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

    /// ✅ FIX: GraphLoaded is now rendered
    if (state is TraceabilityGraphLoaded) {
      final graph = (state as TraceabilityGraphLoaded).graph;
      return TraceabilityGraphExplorer(graph: graph);
    }

    if (state is TraceabilityRecallReady) {
      final recallState = state as TraceabilityRecallReady;
      final domainResult = recallState.projection.domainResult;

      final severity = RecallSeverityService.evaluate(domainResult);
      final severityUi = RecallSeverityUiModel.fromSeverity(severity);

      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: severityUi.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: severityUi.color),
                const SizedBox(width: 8),
                Text(
                  severityUi.label,
                  style: TextStyle(
                    color: severityUi.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  '${domainResult.affectedNodes.length} nodes affected',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: RecallRadar(projection: recallState.projection),
          ),
          Expanded(
            flex: 3,
            child: RecallTimeline(projection: recallState.projection),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: severityUi.color,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Confirm Recall Execution'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            severityUi.label,
                            style: TextStyle(
                              color: severityUi.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Affected Nodes: ${domainResult.affectedNodes.length}',
                          ),
                          Text('Maximum Trace Depth: ${domainResult.maxDepth}'),
                          const SizedBox(height: 16),
                          const Text(
                            'This action will BLOCK all affected nodes '
                            'and create an immutable audit record.\n\n'
                            'Do you want to proceed?',
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: severityUi.color,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            onConfirmRecall(domainResult);
                          },
                          child: const Text('Confirm & Execute'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  'Execute Recall',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    final graph = widget.graph;
    final paths = graph.buildPathsFrom(graph.rootNodeId);

    final levels = <int, List<String>>{};
    for (final id in paths.keys) {
      final depth = graph.depthOf(id, paths);
      levels.putIfAbsent(depth, () => []).add(id);
    }

    final sortedDepths = levels.keys.toList()..sort();
    for (final d in sortedDepths) {
      levels[d]!.sort((a, b) {
        final la = graph.nodes[a]?.label ?? a;
        final lb = graph.nodes[b]?.label ?? b;
        return la.compareTo(lb);
      });
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: _GraphHeader(
            graph: graph,
            onAnalyzeRoot: () {
              context.read<TraceabilityCubit>().analyzeRecall(graph.rootNodeId);
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: _GraphCanvas(
              graph: graph,
              levels: levels,
              sortedDepths: sortedDepths,
              selectedNodeId: _selectedNodeId,
              onNodeTap: (id) {
                setState(() => _selectedNodeId = id);
                _openNodeSheet(context, graph.nodes[id], id);
              },
            ),
          ),
        ),
      ],
    );
  }

  // void _openNodeSheet(BuildContext context, TraceNodeModel? node, String id) {
  //   showModalBottomSheet(
  //     context: context,
  //     showDragHandle: true,
  //     builder: (_) {
  //       final label = node?.label ?? id;
  //       final type = node?.type?.toString() ?? 'unknown';
  //       final status = node?.status?.toString() ?? 'unknown';

  //       return SafeArea(
  //         child: Padding(
  //           padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 label,
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //               ),
  //               const SizedBox(height: 6),
  //               Wrap(
  //                 spacing: 8,
  //                 runSpacing: 8,
  //                 children: [
  //                   _Pill(text: 'Type: $type'),
  //                   _Pill(text: 'Status: $status'),
  //                 ],
  //               ),
  //               const SizedBox(height: 12),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton.icon(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                     context.read<TraceabilityCubit>().analyzeRecall(id);
  //                   },
  //                   icon: const Icon(Icons.warning_amber_rounded),
  //                   label: const Text('Analyze recall impact from this node'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  void _openNodeSheet(BuildContext context, TraceNodeModel? node, String id) {
    final meta = node?.metadata ?? const <String, dynamic>{};

    String? s(dynamic v) => (v == null) ? null : v.toString().trim();
    DateTime? dt(dynamic v) => v is DateTime ? v : null;

    final batchId = s(meta['batchId']) ?? id;

    final product = s(meta['product']) ?? node?.label;
    final productType = s(meta['productType']) ?? s(node?.type) ?? 'Batch';

    final productionLead = s(meta['productionLead']);
    final qcLead = s(meta['qcInspectorName']);

    final prodStart = dt(meta['productionStartTime']);
    final qcDone = dt(meta['qcCompletedAt']);

    final finalStatus = s(node?.status) ?? 'UNKNOWN';
    final statusColor = traceStatusColor(finalStatus);

    String fmt(DateTime? d) {
      if (d == null) return '—';
      final two = (int n) => n.toString().padLeft(2, '0');
      return '${d.year}-${two(d.month)}-${two(d.day)}  ${two(d.hour)}:${two(d.minute)}';
    }

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s(product) ?? 'Batch #$batchId',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Batch #$batchId • $productType',
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 12),

                // Status pill
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      finalStatus.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Responsibility Chain
                const Text(
                  'Responsibility Chain',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 10),

                _InfoRow(
                  label: 'Production Lead',
                  value: productionLead ?? 'Not recorded',
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  label: 'Quality Lead (QC)',
                  value: qcLead ?? 'Not recorded yet',
                  icon: Icons.verified_outlined,
                ),

                const SizedBox(height: 14),

                // Timeline
                const Text(
                  'Timeline',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 10),

                _InfoRow(
                  label: 'Production Start',
                  value: fmt(prodStart),
                  icon: Icons.play_circle_outline,
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  label: 'QC Completed',
                  value: fmt(qcDone),
                  icon: Icons.check_circle_outline,
                ),

                const SizedBox(height: 16),

                // Actions
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<TraceabilityCubit>().analyzeRecall(id);
                    },
                    icon: const Icon(Icons.warning_amber_rounded),
                    label: const Text('Analyze recall impact from this node'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

class _GraphHeader extends StatelessWidget {
  final TraceGraphModel graph;
  final VoidCallback onAnalyzeRoot;

  const _GraphHeader({required this.graph, required this.onAnalyzeRoot});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final root = graph.nodes[graph.rootNodeId];
    final rootLabel = root?.label ?? graph.rootNodeId;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_tree_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rootLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${graph.nodes.length} nodes • ${graph.edges.length} links',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onAnalyzeRoot,
            icon: const Icon(Icons.warning_amber_rounded, size: 18),
            label: const Text('Analyze'),
          ),
        ],
      ),
    );
  }
}

class _GraphCanvas extends StatelessWidget {
  final TraceGraphModel graph;
  final Map<int, List<String>> levels;
  final List<int> sortedDepths;
  final String? selectedNodeId;
  final void Function(String nodeId) onNodeTap;

  const _GraphCanvas({
    required this.graph,
    required this.levels,
    required this.sortedDepths,
    required this.selectedNodeId,
    required this.onNodeTap,
  });

  @override
  Widget build(BuildContext context) {
    const columnWidth = 280.0;
    const rowHeight = 110.0;
    const padding = 24.0;

    int maxRows = 1;
    for (final d in sortedDepths) {
      final len = levels[d]?.length ?? 0;
      if (len > maxRows) maxRows = len;
    }

    final canvasWidth = padding * 2 + (sortedDepths.length * columnWidth);
    final canvasHeight = padding * 2 + (maxRows * rowHeight);

    final positions = <String, Offset>{};
    for (int i = 0; i < sortedDepths.length; i++) {
      final depth = sortedDepths[i];
      final nodes = levels[depth] ?? const <String>[];
      for (int j = 0; j < nodes.length; j++) {
        final id = nodes[j];
        positions[id] = Offset(
          padding + i * columnWidth,
          padding + j * rowHeight,
        );
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: InteractiveViewer(
          minScale: 0.6,
          maxScale: 2.2,
          constrained: false,
          child: SizedBox(
            width: canvasWidth,
            height: canvasHeight,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(canvasWidth, canvasHeight),
                  painter: _EdgePainter(
                    edges: graph.edges,
                    positions: positions,
                  ),
                ),
                for (final entry in positions.entries)
                  Positioned(
                    left: entry.value.dx,
                    top: entry.value.dy,
                    width: columnWidth - 24,
                    child: _NodeCard(
                      node: graph.nodes[entry.key],
                      nodeId: entry.key,
                      isSelected: entry.key == selectedNodeId,
                      onTap: () => onNodeTap(entry.key),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NodeCard extends StatelessWidget {
  final TraceNodeModel? node;
  final String nodeId;
  final bool isSelected;
  final VoidCallback onTap;

  const _NodeCard({
    required this.node,
    required this.nodeId,
    required this.isSelected,
    required this.onTap,
  });

  Color _statusColor(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s.contains('fail') || s.contains('blocked')) return Colors.red;
    if (s.contains('wait') || s.contains('pending')) return Colors.orange;
    if (s.contains('pass') || s.contains('ok')) return Colors.green;
    return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = node?.label ?? nodeId;
    final type = node?.type?.toString() ?? 'unknown';
    final status = node?.status?.toString();
    final statusColor = traceStatusColor(status);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : Colors.grey.withOpacity(0.25),
            width: isSelected ? 2 : 1,
          ),
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.10 : 0.06),
              blurRadius: isSelected ? 18 : 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    type,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        (status ?? 'UNKNOWN').toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _EdgePainter extends CustomPainter {
  final List<dynamic> edges;
  final Map<String, Offset> positions;

  const _EdgePainter({required this.edges, required this.positions});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.35)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final e in edges) {
      final from = (e as dynamic).from?.toString();
      final to = (e as dynamic).to?.toString();
      if (from == null || to == null) continue;
      final a = positions[from];
      final b = positions[to];
      if (a == null || b == null) continue;

      final start = Offset(a.dx + 120, a.dy + 55);
      final end = Offset(b.dx + 12, b.dy + 55);

      final path = Path();
      path.moveTo(start.dx, start.dy);
      final midX = (start.dx + end.dx) / 2;
      path.cubicTo(midX, start.dy, midX, end.dy, end.dx, end.dy);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _EdgePainter oldDelegate) {
    return oldDelegate.edges != edges || oldDelegate.positions != positions;
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
Color traceStatusColor(String? status) {
  final s = (status ?? '').toLowerCase();
  if (s.contains('fail') || s.contains('blocked')) return Colors.red;
  if (s.contains('wait') || s.contains('pending')) return Colors.orange;
  if (s.contains('pass') || s.contains('ok')) return Colors.green;
  return Colors.blueGrey;
}
