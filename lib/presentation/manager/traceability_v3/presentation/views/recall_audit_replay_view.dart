import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/recall_audit_model.dart';
import '../../domain/repositories/traceability_repository.dart';
import '../../domain/engines/recall_engine.dart';

import '../cubit/traceability_cubit.dart';
import '../cubit/traceability_state.dart';
import '../widgets/recall_radar.dart';
import '../widgets/recall_timeline.dart';
import '../projections/recall_ui_mapper.dart';

/// ============================================================
/// 🔁 Recall Audit Replay View (READ-ONLY)
/// ============================================================
///
/// Reconstructs the traceability graph exactly as it would appear
/// for the given audit source node.
///
class RecallAuditReplayView extends StatelessWidget {
  final RecallAuditModel audit;
  final TraceabilityV3Repository  repository;

  const RecallAuditReplayView({
    super.key,
    required this.audit,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TraceabilityCubit(repository)..loadGraph(audit.sourceNodeId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Recall Replay')),
        body: BlocBuilder<TraceabilityCubit, TraceabilityState>(
          builder: (context, state) {
            if (state is TraceabilityLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TraceabilityGraphLoaded) {
              final engine = RecallEngine(state.graph);

              final recallResult = engine.forwardRecall(audit.sourceNodeId);

              final paths = state.graph.buildPathsFrom(audit.sourceNodeId);

              final projection = RecallUiMapper.fromDomain(recallResult, paths);

              return Column(
                children: [
                  /// ====================================================
                  /// 📌 AUDIT HEADER (READ-ONLY)
                  /// ====================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Historical Recall Replay',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Manager: ${audit.managerName}'),
                        Text('Executed: ${audit.executedAt}'),
                        Text('Affected Nodes: ${audit.affectedCount}'),
                        Text('Trace Depth: ${audit.maxDepth}'),
                      ],
                    ),
                  ),

                  /// ====================================================
                  /// 📡 VISUALIZATION (READ-ONLY)
                  /// ====================================================
                  Expanded(flex: 2, child: RecallRadar(projection: projection)),
                  Expanded(
                    flex: 3,
                    child: RecallTimeline(projection: projection),
                  ),

                  /// ====================================================
                  /// 🔒 READ-ONLY FOOTER
                  /// ====================================================
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'This is a historical replay. '
                      'Execution actions are disabled.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is TraceabilityError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
