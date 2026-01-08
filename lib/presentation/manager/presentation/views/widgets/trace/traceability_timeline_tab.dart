import 'package:alwadi_food/presentation/manager/cubit/trace/traceability_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/trace/traceability_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'traceability_widgets.dart';

class TraceabilityTimelineTab extends StatelessWidget {
  const TraceabilityTimelineTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TraceabilityCubit, TraceabilityState>(
      builder: (context, state) {
        if (state.selectedBatch == null) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              TraceEmptyState(
                title: "No Batch Selected",
                subtitle: "Search and select any batch to view full timeline.",
                icon: Icons.timeline_rounded,
              ),
            ],
          );
        }

        final batch = state.selectedBatch!;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TraceSection(
              title: "Batch Timeline",
              subtitle: "Full trace record for batch: ${batch.batchId}",
              child: TraceTimelineLiveCard(
                batchId: batch.batchId,
                product: batch.product,
                line: batch.line,
                events: state.traceEvents,
              ),
            ),
            const SizedBox(height: 18),
            TraceSection(
              title: "QC Evidence",
              subtitle: "All inspections linked to this batch.",
              child: TraceQcResultsCard(results: state.qcResults),
            ),
          ],
        );
      },
    );
  }
}
