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

class TraceabilityViewBody extends StatefulWidget {
  final TraceabilityState state;
  final String rootNodeId;

  /// Current manager identity (from AuthCubit)
  final String managerId;
  final String managerName;

  const TraceabilityViewBody({
    super.key,
    required this.state,
    required this.rootNodeId,
    required this.managerId,
    required this.managerName,
  });

  @override
  State<TraceabilityViewBody> createState() => _TraceabilityViewBodyState();
}

class _TraceabilityViewBodyState extends State<TraceabilityViewBody> {
  String? _auditId;
  String _workflowStatus = 'NONE'; // NONE | DRAFT | PENDING
  int _approvalsCount = 0;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    if (state is TraceabilityLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is TraceabilityGraphLoaded) {
      final graph = state.graph;
      return TraceabilityGraphExplorer(graph: graph);
    }

    if (state is TraceabilityRecallReady) {
      final domainResult = state.projection.domainResult;

      final severity = RecallSeverityService.evaluate(domainResult);
      final severityUi = RecallSeverityUiModel.fromSeverity(severity);

      final requiredApprovals = _requiredApprovals(severity);
      final severityLabel = _severityLabel(severity);

      return Column(
        children: [
          // ============================================================
          // Decision Snapshot (Executive)
          // ============================================================
          _decisionSnapshotCard(
            context,
            severityUi: severityUi,
            severityLabel: severityLabel,
            affected: domainResult.affectedNodes.length,
            depth: domainResult.maxDepth,
            isCritical: domainResult.isCritical,
            requiredApprovals: requiredApprovals,
          ),

          Expanded(
            flex: 2,
            child: RecallRadar(
              projection: state.projection,
              rootNodeId: widget.rootNodeId,
            ),
          ),
          Expanded(
            flex: 3,
            child: RecallTimeline(projection: state.projection),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () => _openApprovalSheet(
                  context,
                  recallResult: domainResult,
                  severityLabel: severityLabel,
                  requiredApprovals: requiredApprovals,
                ),
                child: const Text(
                  "Recall Approval Workflow",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const RecallEmptyState();
  }

  Widget _decisionSnapshotCard(
    BuildContext context, {
    required RecallSeverityUiModel severityUi,
    required String severityLabel,
    required int affected,
    required int depth,
    required bool isCritical,
    required int requiredApprovals,
  }) {
    final scheme = Theme.of(context).colorScheme;

    final status = switch (_workflowStatus) {
      'DRAFT' => 'DRAFT',
      'PENDING' => 'PENDING',
      _ => 'READY',
    };

    final statusTint = switch (_workflowStatus) {
      'DRAFT' => scheme.primary,
      'PENDING' => severityUi.color,
      _ => Colors.black87,
    };

    final approvalsText = _workflowStatus == 'PENDING'
        ? "Approvals: $_approvalsCount/$requiredApprovals"
        : _workflowStatus == 'DRAFT'
        ? "Draft prepared"
        : "Awaiting decision";

    final confidence = isCritical
        ? "High confidence: impact is concentrated across multiple downstream nodes."
        : "Moderate confidence: impact is limited; verify evidence before executing.";

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withOpacity(0.92),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: severityUi.color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: severityUi.color.withOpacity(0.16)),
                ),
                child: Icon(Icons.gpp_good_rounded, color: severityUi.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Decision Snapshot",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      approvalsText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              _pill(text: status, tint: statusTint),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _miniKpi(
                context,
                label: "Impact",
                value: "$affected nodes",
                tint: scheme.primary,
              ),
              const SizedBox(width: 10),
              _miniKpi(
                context,
                label: "Depth",
                value: depth.toString(),
                tint: scheme.primary,
              ),
              const SizedBox(width: 10),
              _miniKpi(
                context,
                label: "Risk",
                value: severityLabel,
                tint: severityUi.color,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: scheme.primary.withOpacity(0.06),
              border: Border.all(color: scheme.primary.withOpacity(0.12)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_rounded, color: scheme.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    confidence,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniKpi(
    BuildContext context, {
    required String label,
    required String value,
    required Color tint,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: tint.withOpacity(0.08),
          border: Border.all(color: tint.withOpacity(0.14)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.2,
                color: Colors.black87,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _requiredApprovals(RecallSeverity s) {
    // Simple rule: HIGH needs 2 approvals
    return s == RecallSeverity.high ? 2 : 1;
  }

  String _severityLabel(RecallSeverity s) {
    switch (s) {
      case RecallSeverity.low:
        return 'LOW';
      case RecallSeverity.medium:
        return 'MEDIUM';
      case RecallSeverity.high:
        return 'HIGH';
    }
  }

  Future<void> _openApprovalSheet(
    BuildContext context, {
    required RecallResultModel recallResult,
    required String severityLabel,
    required int requiredApprovals,
  }) async {
    final scheme = Theme.of(context).colorScheme;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Colors.white.withOpacity(0.98),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: scheme.primary.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: scheme.primary.withOpacity(0.18),
                            ),
                          ),
                          child: Icon(
                            Icons.verified_user_rounded,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Approval Workflow",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.2,
                                  color: Colors.black87,
                                ),
                          ),
                        ),
                        _statusChip(_workflowStatus, scheme),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Draft → Pending → Executed. "
                      "High risk requires $requiredApprovals approvals.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface.withOpacity(0.65),
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 14),

                    _kpiRow(
                      context,
                      leftLabel: "Affected",
                      leftValue: "${recallResult.affectedNodes.length}",
                      rightLabel: "Max Depth",
                      rightValue: "${recallResult.maxDepth}",
                    ),

                    const SizedBox(height: 14),

                    // ======================================================
                    // Actions
                    // ======================================================
                    if (_workflowStatus == 'NONE') ...[
                      _primaryAction(
                        context,
                        icon: Icons.edit_note_rounded,
                        title: "Create Draft",
                        subtitle: "Creates an audit draft (no blocking yet).",
                        onTap: () async {
                          final id = await context
                              .read<TraceabilityCubit>()
                              .createRecallDraft(
                                recallResult: recallResult,
                                managerId: widget.managerId,
                                managerName: widget.managerName,
                                severityLabel: severityLabel,
                                requiredApprovals: requiredApprovals,
                              );

                          if (id != null) {
                            setState(() {
                              _auditId = id;
                              _workflowStatus = 'DRAFT';
                              _approvalsCount = 0;
                            });
                            if (mounted) Navigator.pop(context);
                            _toast(context, "Draft created.");
                          }
                        },
                      ),
                    ] else ...[
                      _secondaryRow(
                        context,
                        items: [
                          _miniButton(
                            context,
                            icon: Icons.send_rounded,
                            label: "Submit",
                            enabled: _workflowStatus == 'DRAFT',
                            onTap: () async {
                              if (_auditId == null) return;
                              final ok = await context
                                  .read<TraceabilityCubit>()
                                  .submitRecallForApproval(auditId: _auditId!);
                              if (ok) {
                                setState(() => _workflowStatus = 'PENDING');
                                if (mounted) Navigator.pop(context);
                                _toast(context, "Submitted for approval.");
                              }
                            },
                          ),
                          _miniButton(
                            context,
                            icon: Icons.how_to_reg_rounded,
                            label: "Approve",
                            enabled: _workflowStatus == 'PENDING',
                            onTap: () async {
                              if (_auditId == null) return;

                              // For second approval on HIGH: ask for approver name
                              final approver = await _askApprover(context);
                              if (approver == null) return;

                              final ok = await context
                                  .read<TraceabilityCubit>()
                                  .addApproval(
                                    auditId: _auditId!,
                                    approverId: approver['id']!,
                                    approverName: approver['name']!,
                                  );
                              if (ok) {
                                setState(() => _approvalsCount += 1);
                                _toast(
                                  context,
                                  "Approval recorded ($_approvalsCount/$requiredApprovals).",
                                );
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: scheme.primary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: scheme.primary.withOpacity(0.14),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.rule_rounded,
                              size: 18,
                              color: scheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Approvals: $_approvalsCount / $requiredApprovals",
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      _primaryAction(
                        context,
                        icon: Icons.lock_open_rounded,
                        title: "Execute (After Approval)",
                        subtitle:
                            "Blocks all affected nodes and finalizes the audit.",
                        enabled:
                            _workflowStatus == 'PENDING' &&
                            _approvalsCount >= requiredApprovals,
                        onTap: () async {
                          if (_auditId == null) return;
                          await context
                              .read<TraceabilityCubit>()
                              .executeApprovedRecall(
                                auditId: _auditId!,
                                recallResult: recallResult,
                              );
                          if (mounted) Navigator.pop(context);
                        },
                      ),
                    ],

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
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

  Future<Map<String, String>?> _askApprover(BuildContext context) async {
    final ctrl = TextEditingController();
    final idCtrl = TextEditingController();

    return showDialog<Map<String, String>?>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text("Approval"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrl,
                decoration: const InputDecoration(labelText: "Approver name"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: idCtrl,
                decoration: const InputDecoration(
                  labelText: "Approver ID (optional)",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final name = ctrl.text.trim();
                if (name.isEmpty) return;
                Navigator.pop(context, {
                  'name': name,
                  'id': (idCtrl.text.trim().isEmpty)
                      ? name.toLowerCase()
                      : idCtrl.text.trim(),
                });
              },
              child: const Text("Approve"),
            ),
          ],
        );
      },
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _pill({required String text, required Color tint}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: tint.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tint.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: tint,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _statusChip(String status, ColorScheme scheme) {
    Color tint;
    String label;
    switch (status) {
      case 'DRAFT':
        tint = scheme.primary;
        label = 'DRAFT';
        break;
      case 'PENDING':
        tint = const Color(0xFFFF8F00);
        label = 'PENDING';
        break;
      default:
        tint = Colors.black54;
        label = 'READY';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: tint.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tint.withOpacity(0.18)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 11,
          color: tint,
        ),
      ),
    );
  }

  Widget _kpiRow(
    BuildContext context, {
    required String leftLabel,
    required String leftValue,
    required String rightLabel,
    required String rightValue,
  }) {
    return Row(
      children: [
        Expanded(child: _kpiCard(context, leftLabel, leftValue)),
        const SizedBox(width: 12),
        Expanded(child: _kpiCard(context, rightLabel, rightValue)),
      ],
    );
  }

  Widget _kpiCard(BuildContext context, String label, String value) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.surface.withOpacity(0.75),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
              color: Colors.black87,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(22),
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withOpacity(0.96),
            border: Border.all(color: Colors.black.withOpacity(0.06)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 22,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: scheme.primary.withOpacity(0.18)),
                ),
                child: Icon(icon, color: scheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface.withOpacity(0.65),
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: scheme.primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _secondaryRow(BuildContext context, {required List<Widget> items}) {
    return Row(children: items.map((w) => Expanded(child: w)).toList());
  }

  Widget _miniButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        child: Opacity(
          opacity: enabled ? 1 : 0.45,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: scheme.primary.withOpacity(0.06),
              border: Border.all(color: scheme.primary.withOpacity(0.14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: scheme.primary,
                    fontSize: 12,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 8, 16),
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
