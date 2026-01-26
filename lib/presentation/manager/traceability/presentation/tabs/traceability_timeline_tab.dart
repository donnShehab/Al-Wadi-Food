// import 'package:alwadi_food/presentation/manager/traceability/cubit/traceability_cubit.dart';
// import 'package:alwadi_food/presentation/manager/traceability/cubit/traceability_state.dart';
// import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_empty_state.dart';
// import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_loading_state.dart';
// import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_timeline_stepper.dart';
// import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_qc_evidence_section.dart';
// import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_batch_summary_card.dart';
// import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_status_command_bar.dart';
// import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_evidence_summary_card.dart';
// import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_decision_bar.dart';
// import 'package:alwadi_food/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class TraceabilityTimelineTab extends StatelessWidget {
//   const TraceabilityTimelineTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<TraceabilityCubit, TraceabilityState>(
//       builder: (context, state) {
//         if (state.status == TraceabilityViewStatus.loadingBundle) {
//           return const TraceLoadingState(
//             title: "Loading batch trace...",
//             subtitle: "Fetching batch + timeline + QC evidence in realtime.",
//           );
//         }

//         if (state.status == TraceabilityViewStatus.error) {
//           return TraceEmptyState(
//             icon: Icons.error_rounded,
//             title: "Failed to load batch",
//             subtitle: state.error ?? "Unknown error",
//             action: FilledButton.icon(
//               onPressed: () => DefaultTabController.of(context).animateTo(0),
//               icon: const Icon(Icons.search_rounded),
//               label: const Text("Back to Search"),
//             ),
//           );
//         }

//         final bundle = state.selectedBundle;
//         if (bundle == null) {
//           return TraceEmptyState(
//             icon: Icons.track_changes_rounded,
//             title: "No batch selected",
//             subtitle:
//                 "Select a batch from Search to view timeline and QC evidence.",
//             action: FilledButton.icon(
//               onPressed: () => DefaultTabController.of(context).animateTo(0),
//               icon: const Icon(Icons.search_rounded),
//               label: const Text("Go to Search"),
//             ),
//           );
//         }

//         return Stack(
//           children: [
//             SingleChildScrollView(
//               padding: const EdgeInsets.fromLTRB(
//                 AppSpacing.md,
//                 AppSpacing.md,
//                 AppSpacing.md,
//                 120, // space for sticky decision bar
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TraceBatchSummaryCard(batch: bundle.batch),
//                   const SizedBox(height: AppSpacing.md),

//                   // ✅ Status Command Bar (Manager decision header)
//                   TraceStatusCommandBar(bundle: bundle),
//                   const SizedBox(height: AppSpacing.md),

//                   // ✅ Evidence Summary
//                   TraceEvidenceSummaryCard(bundle: bundle),
//                   const SizedBox(height: AppSpacing.lg),

//                   Text(
//                     "Timeline",
//                     style: Theme.of(context).textTheme.titleLarge?.bold,
//                   ),
//                   const SizedBox(height: 8),
//                   TraceTimelineStepper(events: bundle.events),

//                   const SizedBox(height: AppSpacing.lg),
//                   Text(
//                     "QC Evidence",
//                     style: Theme.of(context).textTheme.titleLarge?.bold,
//                   ),
//                   const SizedBox(height: 8),
//                   TraceQcEvidenceSection(qcResults: bundle.qcResults),
//                   const SizedBox(height: AppSpacing.xl),
//                 ],
//               ),
//             ),

//             // ✅ Sticky manager decision bar
//             const Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: TraceDecisionBar(),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
