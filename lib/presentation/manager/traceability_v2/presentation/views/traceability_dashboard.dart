
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/projections/trace_recall_projection.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/presentation/cubit/traceability_cubit.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/presentation/widgets/recall_radar.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/presentation/widgets/recall_timeline.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/presentation/widgets/severity_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TraceabilityDashboard extends StatelessWidget {
  final String rootNodeId;

  const TraceabilityDashboard({super.key, required this.rootNodeId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TraceabilityCubit, TraceabilityState>(
      builder: (context, state) {
        if (state is TraceabilityLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RecallAnalysisReady) {
          return Column(
            children: [
              SeverityBadge(severity: state.severity),
              RecallRadar(
                projection: TraceRecallProjection.fromDomain(state.impact),
              ),
              RecallTimeline(
                projection: TraceRecallProjection.fromDomain(state.impact),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => context
                        .read<TraceabilityCubit>()
                        .exportRecallReport(state.impact),
                    child: const Text('Export Recall PDF'),
                  ),
                 ElevatedButton(
                    onPressed: () =>
                        context.read<TraceabilityCubit>().executeRecall(
                          impact: state.impact,
                          severity: state.severity,
                          managerId:
                              'manager_001', // 🔐 Replace with auth user ID later
                        ),
                    child: const Text('Execute Recall'),
                  ),

                ],
              ),
            ],
          );
        }

        return const Center(child: Text('Load a batch to begin'));
      },
    );
  }
}
