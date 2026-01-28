import 'package:alwadi_food/core/helper_functions/manager_fields_helper.dart';
import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_state.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_action/traceability_certificate_pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';

import 'action_center_filter_chips.dart'; // contains ActionCenterFilter enum
import 'premium_batch_card.dart';

class ManagerActionNeededViewBody extends StatelessWidget {
  final ActionCenterFilter selectedFilter;
  const ManagerActionNeededViewBody({super.key, required this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagerActionNeededCubit, ManagerActionNeededState>(
      builder: (context, state) {
        if (state is ManagerActionNeededLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ManagerActionNeededError) {
          return Center(child: Text(state.message));
        }
        if (state is! ManagerActionNeededLoaded) {
          return const SizedBox.shrink();
        }

        final pdf = TraceabilityCertificatePdfService();

        List<Map<String, dynamic>> items;
        String header;
        String subtitle;
        String? forceStatus;

        switch (selectedFilter) {
          case ActionCenterFilter.pending:
            items = state.pendingBatches;
            header = "Pending / Waiting QC";
            subtitle = "Batches awaiting inspection or decision";
            forceStatus = null;
            break;

          case ActionCenterFilter.failed:
            items = state.failedInspections;
            header = "Rejected / Failed";
            subtitle = "Require traceability review";
            forceStatus = "FAILED";
            break;

          case ActionCenterFilter.approved:
            items = state.approvedBatches;
            header = "Approved / Accepted";
            subtitle = "Healthy batches (green)";
            forceStatus = "PASSED";
            break;

          case ActionCenterFilter.highRisk:
            items = state.highRiskAlerts;
            header = "High Risk Alerts";
            subtitle = "Immediate attention";
            forceStatus = "HIGH_RISK";
            break;

          case ActionCenterFilter.archived:
            items = state.blockedBatches;
            header = "Resolved / Archived";
            subtitle = "Recall executed (blocked)";
            forceStatus = "BLOCKED";
            break;
        }

        if (items.isEmpty) {
          return const Center(child: Text("No items 🎉"));
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _Header(title: header, subtitle: subtitle),
            const SizedBox(height: 12),

            AnimationLimiter(
              child: Column(
                children: List.generate(items.length, (i) {
                  final x = items[i]; // ✅ current item is x

                  final batchId = (x["batchId"] ?? x["id"] ?? "").toString();
                  final title = ManagerFieldsHelper.productName(x);
                  final line = (x["line"] ?? x["productionLine"] ?? "Unknown")
                      .toString();

                  // ✅ Image fix (as you already intended)
                  final imageUrl = (x["imageUrl"] ?? "").toString();

                  final statusRaw =
                      (forceStatus ?? (x["status"] ?? x["result"] ?? ""))
                          .toString();

                  return AnimationConfiguration.staggeredList(
                    position: i,
                    duration: const Duration(milliseconds: 350),
                    child: SlideAnimation(
                      verticalOffset: 18,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PremiumBatchCard(
                            title: title,
                            subtitle: 'Batch #$batchId • Line $line',
                            statusRaw: statusRaw,
                            imageUrl: imageUrl,
                            onTap: () {
                              context.push(
                                AppRouter.KTraceabilityView,
                                extra: {'rootNodeId': batchId},
                              );
                            },

                            // ✅ FIX: pass batch: x (NOT batch: batch)
                            onPdf: () async {
                              await pdf.previewInApp(
                                context: context,
                                batch: x,
                                embedImage: true,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? color;

  const _Header({required this.title, required this.subtitle, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.black;

    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: c,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
