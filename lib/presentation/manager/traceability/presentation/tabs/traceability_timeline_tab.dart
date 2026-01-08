import 'package:alwadi_food/presentation/manager/traceability/cubit/traceability_cubit.dart';
import 'package:alwadi_food/presentation/manager/traceability/cubit/traceability_state.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_attention_banner.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_batch_summary_card.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_empty_state.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_loading_state.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_qc_evidence_section.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_timeline_stepper.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TraceabilityTimelineTab extends StatelessWidget {
  const TraceabilityTimelineTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TraceabilityCubit, TraceabilityState>(
      builder: (context, state) {
        if (state.status == TraceabilityViewStatus.loading) {
          return const TraceLoadingState(
            title: "Loading batch trace...",
            subtitle: "Fetching timeline and QC evidence.",
          );
        }

        if (state.selected == null) {
          return TraceEmptyState(
            icon: Icons.track_changes_rounded,
            title: "No batch selected",
            subtitle:
                "Select a batch from Search to view its full trace timeline and QC evidence.",
            action: FilledButton.icon(
              onPressed: () => DefaultTabController.of(context).animateTo(0),
              icon: const Icon(Icons.search_rounded),
              label: const Text("Go to Search"),
            ),
          );
        }

        final bundle = state.selected!;
        final batch = bundle.batch;

        TraceAttentionBanner? banner;
        if (bundle.isFailed) {
          banner = const TraceAttentionBanner(
            type: TraceBannerType.danger,
            title: "Immediate Attention Required",
            message: "This batch failed QC. Review evidence and take action.",
          );
        } else if (bundle.isWaitingQc) {
          banner = const TraceAttentionBanner(
            type: TraceBannerType.warning,
            title: "Pending QC Inspection",
            message:
                "This batch is waiting for QC. Timeline will update after inspection.",
          );
        } else if (bundle.isTimelineEmpty) {
          banner = const TraceAttentionBanner(
            type: TraceBannerType.warning,
            title: "Timeline Missing",
            message:
                "No trace events were found. If this is an older batch, it may predate trace tracking.",
          );
        }

        return SingleChildScrollView(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TraceBatchSummaryCard(batch: batch),
              const SizedBox(height: AppSpacing.md),
              if (banner != null) ...[
                banner,
                const SizedBox(height: AppSpacing.md),
              ],

              Text(
                "Timeline",
                style: Theme.of(context).textTheme.titleLarge?.bold,
              ),
              const SizedBox(height: 8),
              TraceTimelineStepper(events: bundle.events),

              const SizedBox(height: AppSpacing.lg),
              Text(
                "QC Evidence",
                style: Theme.of(context).textTheme.titleLarge?.bold,
              ),
              const SizedBox(height: 8),
              TraceQcEvidenceSection(qcResults: bundle.qcResults),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        );
      },
    );
  }
}
