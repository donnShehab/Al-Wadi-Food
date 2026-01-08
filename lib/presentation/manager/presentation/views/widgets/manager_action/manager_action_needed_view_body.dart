import 'package:alwadi_food/core/helper_functions/manager_fields_helper.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_state.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_action/action_needed_item_tile.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_action/action_needed_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'qc_assign_selector_dialog.dart';

class ManagerActionNeededViewBody extends StatelessWidget {
  final DateTime? lastUpdated;
  final VoidCallback onRefreshTap;

  const ManagerActionNeededViewBody({
    super.key,
    required this.lastUpdated,
    required this.onRefreshTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagerActionNeededCubit, ManagerActionNeededState>(
      builder: (context, state) {
        if (state is ManagerActionNeededLoading) {
          return ListView(
            children: const [
              SizedBox(height: 200),
              Center(child: CircularProgressIndicator()),
            ],
          );
        }

        if (state is ManagerActionNeededLoaded) {
          final totalItems =
              state.highRiskAlerts.length +
              state.pendingBatches.length +
              state.failedInspections.length;

          // ============================================================
          // ✅ SORTING: High Temp first, then High Moisture
          // ============================================================
          final sortedHighRisk = [...state.highRiskAlerts];
          sortedHighRisk.sort((a, b) {
            final tempA = (a["temperature"] ?? 0).toDouble();
            final tempB = (b["temperature"] ?? 0).toDouble();

            final moistA = (a["moisture"] ?? 0).toDouble();
            final moistB = (b["moisture"] ?? 0).toDouble();

            final isHighTempA = tempA > 10;
            final isHighTempB = tempB > 10;

            if (isHighTempA && !isHighTempB) return -1;
            if (!isHighTempA && isHighTempB) return 1;

            final isHighMoistA = moistA > 15;
            final isHighMoistB = moistB > 15;

            if (isHighMoistA && !isHighMoistB) return -1;
            if (!isHighMoistA && isHighMoistB) return 1;

            return 0;
          });

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSummaryHeader(
                totalItems: totalItems,
                lastUpdated: lastUpdated,
                onRefreshTap: onRefreshTap,
              ),
              const SizedBox(height: 18),

              // ============================================================
              // ✅ High Risk Alerts
              // ============================================================
              ActionNeededSectionCard(
                title: "High Risk Alerts",
                subtitle: "Food safety critical issues",
                count: sortedHighRisk.length,
                icon: Icons.warning_amber_rounded,
                color: Colors.red,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => context.push(
                        AppRouter.KManagerResolvedAlertsHistoryView,
                      ),
                      icon: const Icon(Icons.history),
                      label: const Text("View Resolved"),
                    ),
                  ),
                  const SizedBox(height: 6),

                  ...sortedHighRisk.map((i) {
                    final name = ManagerFieldsHelper.productName(i);
                    final line = ManagerFieldsHelper.lineName(i);
                    final imageUrl = ManagerFieldsHelper.imageUrl(i);

                    final inspectionId = (i["id"] ?? "").toString();

                    final assignedName = (i["assignedQcName"] ?? "").toString();
                    final isAssigned = assignedName.isNotEmpty;

                    return ActionNeededItemTile(
                      title: name,
                      subtitle: "Line: $line",
                      imageUrl: imageUrl,
                      badgeText: "CRITICAL",
                      badgeColor: Colors.red,

                      isAssigned: isAssigned,
                      assignedTo: assignedName,

                      /// ✅ Open QC Details
                      onOpen: () => context.push(
                        "${AppRouter.KQCDetailsView}/$inspectionId",
                      ),

                      /// ✅ Resolve (Toast + remove instantly)
                      onResolve: () async {
                        final note = await _showResolveDialog(context);
                        if (note == null) return;
                        if (!context.mounted) return;

                        final cubit = context.read<ManagerActionNeededCubit>();

                        // ✅ remove instantly
                        cubit.removeHighRiskItem(inspectionId);

                        final user = FirebaseAuth.instance.currentUser;

                        final managerId = user?.uid ?? "unknown";
                        final managerName =
                            user?.displayName?.trim().isNotEmpty == true
                            ? user!.displayName!
                            : "Manager";

                        final success = await cubit.resolveAlert(
                          inspectionId: inspectionId,
                          managerId: managerId,
                          managerName: managerName,
                          note: note,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? "✅ Resolved Successfully"
                                    : "❌ Resolve failed",
                              ),
                              backgroundColor: success
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          );
                        }
                      },

                      /// ✅ Assign / Re-assign QC
                      onAssign: () => _handleAssign(context, inspectionId),
                    );
                  }).toList(),
                ],
              ),

              const SizedBox(height: 18),

              // ============================================================
              // ✅ Pending QC
              // ============================================================
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
                    onAssign: null,
                    onResolve: null,
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              // ============================================================
              // ✅ Today Failures
              // ============================================================
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
                      "${AppRouter.KManagerBatchDetailsView}/${i["batchId"]}",
                    ),
                    onResolve: null,
                    onAssign: null,
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),
            ],
          );
        }

        if (state is ManagerActionNeededError) {
          return ListView(
            children: [
              const SizedBox(height: 140),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 44,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.message,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: onRefreshTap,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  // ============================================================
  // ✅ Assign Flow (Selector)
  // ============================================================
  Future<void> _handleAssign(BuildContext context, String inspectionId) async {
    final cubit = context.read<ManagerActionNeededCubit>();

    final qcUsers = await cubit.fetchQcUsers();
    if (qcUsers.isEmpty) return;

    final selected = await QCAssignSelectorDialog.show(context, qcUsers);
    if (selected == null) return;

    if (!context.mounted) return;

    final success = await cubit.assignQc(
      inspectionId: inspectionId,
      qcId: selected["qcId"]!,
      qcName: selected["qcName"]!,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? "✅ Assigned Successfully" : "❌ Assign failed",
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) onRefreshTap();
    }
  }

  // ============================================================
  // ✅ Resolve Dialog
  // ============================================================
  Future<String?> _showResolveDialog(BuildContext context) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Resolve Alert ✅"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Resolve note..."),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ Summary Header
  // ============================================================
  Widget _buildSummaryHeader({
    required int totalItems,
    required DateTime? lastUpdated,
    required VoidCallback onRefreshTap,
  }) {
    final updatedText = lastUpdated == null
        ? "-"
        : "${lastUpdated!.hour.toString().padLeft(2, "0")}:${lastUpdated!.minute.toString().padLeft(2, "0")}";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: totalItems > 0
                ? Colors.red.withOpacity(0.10)
                : Colors.green.withOpacity(0.10),
            child: Icon(
              totalItems > 0 ? Icons.warning_amber_rounded : Icons.check_circle,
              color: totalItems > 0 ? Colors.red : Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  totalItems > 0
                      ? "$totalItems items need attention"
                      : "Everything looks good ✅",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Last updated: $updatedText",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onRefreshTap,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text("Refresh"),
          ),
        ],
      ),
    );
  }
}
