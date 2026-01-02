import 'package:alwadi_food/core/helper_functions/manager_fields_helper.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_state.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_action/action_needed_item_tile.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_action/action_needed_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

class ManagerActionNeededViewBody extends StatelessWidget {
  const ManagerActionNeededViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagerActionNeededCubit, ManagerActionNeededState>(
      builder: (context, state) {
        if (state is ManagerActionNeededLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ManagerActionNeededLoaded) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              /// ✅ High Risk Alerts
              ActionNeededSectionCard(
                title: "High Risk Alerts",
                subtitle: "Food safety critical issues",
                count: state.highRiskAlerts.length,
                icon: Icons.warning_amber_rounded,
                color: Colors.red,
                children: state.highRiskAlerts.map((i) {
                  final name = ManagerFieldsHelper.productName(i);
                  final line = ManagerFieldsHelper.lineName(i);
                  final imageUrl = ManagerFieldsHelper.imageUrl(i);

                  return ActionNeededItemTile(
                    title: name,
                    subtitle: "Line: $line",
                    imageUrl: imageUrl,
                    badgeText: "CRITICAL",
                    badgeColor: Colors.red,
                    onOpen: () => context.push(
                      "${AppRouter.KQCInspectionView}/${i["batchId"]}",
                    ),
                    onResolve: () {
                      context.read<ManagerActionNeededCubit>().resolveAlert(
                        i["id"],
                        "manager123", // لاحقاً من auth
                      );
                    },
                    onAssign: () async {
                      // ✅ حالياً assign ثابت - لاحقاً popup select user
                      context.read<ManagerActionNeededCubit>().assignQc(
                        i["id"],
                        "qc123",
                        "QC User",
                      );
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              /// ✅ Pending QC
              ActionNeededSectionCard(
                title: "Pending QC Inspections",
                subtitle: "Batches waiting QC approval",
                count: state.pendingBatches.length,
                icon: Icons.hourglass_bottom_rounded,
                color: Colors.orange,
                children: state.pendingBatches.map((b) {
                  final name = ManagerFieldsHelper.productName(b);
                  final line = ManagerFieldsHelper.lineName(b);
                  final imageUrl = ManagerFieldsHelper.imageUrl(b);

                  return ActionNeededItemTile(
                    title: name,
                    subtitle: "Line: $line • Qty: ${b["quantity"]}",
                    imageUrl: imageUrl,
                    badgeText: "WAITING",
                    badgeColor: Colors.orange,
                    onOpen: () => context.push(AppRouter.KqCPendingListView),
                    onAssign: () async {
                      // لاحقاً assign direct
                    },
                    onResolve: null,
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              /// ✅ Failures Today
              ActionNeededSectionCard(
                title: "Today Failures",
                subtitle: "Failed inspections requiring action",
                count: state.failedInspections.length,
                icon: Icons.close_rounded,
                color: Colors.redAccent,
                children: state.failedInspections.map((i) {
                  final name = ManagerFieldsHelper.productName(i);
                  final line = ManagerFieldsHelper.lineName(i);
                  final imageUrl = ManagerFieldsHelper.imageUrl(i);

                  return ActionNeededItemTile(
                    title: name,
                    subtitle:
                        "Line: $line • Reason: ${i["failureReason"] ?? "-"}",
                    imageUrl: imageUrl,
                    badgeText: "FAILED",
                    badgeColor: Colors.redAccent,
                    onOpen: () => context.push(
                      "${AppRouter.KQCInspectionView}/${i["batchId"]}",
                    ),
                    onResolve: null,
                    onAssign: null,
                  );
                }).toList(),
              ),
            ],
          );
        }

        if (state is ManagerActionNeededError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
