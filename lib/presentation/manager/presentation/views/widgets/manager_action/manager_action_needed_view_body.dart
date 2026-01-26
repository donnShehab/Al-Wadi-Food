// import 'package:alwadi_food/core/helper_functions/manager_fields_helper.dart';
// import 'package:alwadi_food/core/router/app_router.dart';
// import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_cubit.dart';
// import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_state.dart';
// import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_action/action_needed_item_tile.dart';
// import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_action/action_needed_section_card.dart';
// import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_action/qc_assign_selector_dialog.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class ManagerActionNeededViewBody extends StatelessWidget {
//   final DateTime? lastUpdated;
//   final VoidCallback onRefreshTap;

//   const ManagerActionNeededViewBody({
//     super.key,
//     required this.lastUpdated,
//     required this.onRefreshTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ManagerActionNeededCubit, ManagerActionNeededState>(
//       builder: (context, state) {
//         if (state is ManagerActionNeededLoading) {
//           return const Center(child: CircularProgressIndicator(strokeWidth: 2));
//         }

//         if (state is ManagerActionNeededError) {
//           return _buildErrorState(context, state.message);
//         }

//         if (state is ManagerActionNeededLoaded) {
//           final displayTime = lastUpdated ?? state.lastUpdated; //
//           final totalItems =
//               state.highRiskAlerts.length +
//               state.pendingBatches.length +
//               state.failedInspections.length; //

//           return RefreshIndicator(
//             onRefresh: () async => onRefreshTap(),
//             child: ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//               children: [
//                 _buildSummaryHeader(totalItems, displayTime),
//                 const SizedBox(height: 24),

//                 // قسم التنبيهات عالية الخطورة
//                 if (state.highRiskAlerts.isNotEmpty)
//                   ActionNeededSectionCard(
//                     title: "High Risk Alerts",
//                     subtitle: "Immediate safety actions required",
//                     count: state.highRiskAlerts.length,
//                     icon: Icons.warning_amber_rounded,
//                     color: Colors.red.shade700,
//                     children: state.highRiskAlerts.map((item) {
//                       final id = (item["id"] ?? "").toString();
//                       final qcName = (item["assignedQcName"] ?? "").toString();
//                       return ActionNeededItemTile(
//                         title: ManagerFieldsHelper.productName(item),
//                         subtitle: "Line: ${ManagerFieldsHelper.lineName(item)}",
//                         imageUrl: ManagerFieldsHelper.imageUrl(item),
//                         badgeText: "CRITICAL",
//                         badgeColor: Colors.red,
//                         isAssigned: qcName.isNotEmpty,
//                         assignedTo: qcName,
//                         onOpen: () =>
//                             context.push("${AppRouter.KQCDetailsView}/$id"),
//                         onAssign: () => _handleAssign(context, id),
//                         onResolve: () =>
//                             _handleResolve(context, id), // تم تحديثها بالأسفل
//                       );
//                     }).toList(),
//                   ),

//                 // يمكنك إضافة الأقسام الأخرى هنا بنفس النمط (Pending/Failed)
//               ],
//             ),
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   }

//   // --- منطق الحل (Resolve) مع نافذة الملاحظات ---
//   Future<void> _handleResolve(BuildContext context, String inspectionId) async {
//     final TextEditingController noteController = TextEditingController();
//     final cubit = context.read<ManagerActionNeededCubit>();
//     final user = FirebaseAuth.instance.currentUser;

//     final bool? confirm = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Row(
//           children: [
//             Icon(Icons.check_circle_outline, color: Colors.green),
//             SizedBox(width: 10),
//             Text("Confirm Resolution"),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Describe the action taken to clear this risk:"),
//             const SizedBox(height: 12),
//             TextField(
//               controller: noteController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 hintText:
//                     "e.g. Temperature verified manually, batch released...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey.shade50,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: const Text("RESOLVE NOW"),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       final success = await cubit.resolveAlert(
//         inspectionId: inspectionId,
//         managerId: user?.uid ?? "unknown", //
//         managerName: user?.displayName ?? "Manager", //
//         note: noteController.text.trim().isEmpty
//             ? "Resolved by Manager"
//             : noteController.text.trim(), //
//       );

//       if (success && context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Action marked as resolved"),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     }
//   }

//   // --- منطق التعيين (Assign QC) ---
//   Future<void> _handleAssign(BuildContext context, String inspectionId) async {
//     final cubit = context.read<ManagerActionNeededCubit>();
//     final users = await cubit.fetchQcUsers(); //

//     if (context.mounted) {
//       final selected = await QCAssignSelectorDialog.show(context, users);
//       if (selected != null) {
//         await cubit.assignQc(
//           inspectionId: inspectionId,
//           qcId: selected["uid"] ?? "",
//           qcName: selected["name"] ?? "Unknown QC",
//         ); //
//       }
//     }
//   }

//   Widget _buildSummaryHeader(int totalItems, DateTime? time) {
//     final updatedTime = time == null
//         ? "--:--"
//         : "${time.hour}:${time.minute.toString().padLeft(2, '0')}";

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue.shade900, Colors.blue.shade600],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.3),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Action Required",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 "Total Issues: $totalItems",
//                 style: const TextStyle(color: Colors.white70),
//               ),
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               const Icon(
//                 Icons.history_toggle_off,
//                 color: Colors.white60,
//                 size: 20,
//               ),
//               Text(
//                 updatedTime,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState(BuildContext context, String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, color: Colors.red, size: 40),
//           const SizedBox(height: 16),
//           Text(message, textAlign: TextAlign.center),
//           ElevatedButton(onPressed: onRefreshTap, child: const Text("Retry")),
//         ],
//       ),
//     );
//   }
// }
// presentation/manager/action_needed/manager_action_needed_view_body.dart

import 'package:alwadi_food/core/helper_functions/manager_fields_helper.dart';
import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

        if (state is ManagerActionNeededError) {
          return Center(child: Text(state.message));
        }

        if (state is ManagerActionNeededLoaded) {
          final hasItems =
              state.failedInspections.isNotEmpty ||
              state.highRiskAlerts.isNotEmpty ||
              state.pendingBatches.isNotEmpty;

          if (!hasItems) {
            return const Center(child: Text("No actions required 🎉"));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 🔴 FAILED INSPECTIONS (MAIN FIX)
              if (state.failedInspections.isNotEmpty) ...[
                _SectionHeader(
                  title: "Failed Batches",
                  subtitle: "Require traceability review",
                  color: Colors.red,
                ),
               ...state.failedInspections.map((batch) {
                  final batchId = (batch['batchId'] ?? batch['id']).toString();

                  // Uses: productType, productName, name, product (in that order)
                  final productName = ManagerFieldsHelper.productName(batch);

                  return _BatchActionCard(
                    batchId: batchId,
                    title: productName,
                    subtitle: 'Batch #$batchId • Status: FAILED',
                    onTap: () {
                      context.push(
                        AppRouter.KTraceabilityView,
                        extra: {
                          'rootNodeId': batchId,
                        }, // ✅ this is what Traceability expects
                      );
                    },
                  );
                }),

              ],

              // 🔶 HIGH RISK (optional)
              if (state.highRiskAlerts.isNotEmpty) ...[
                const SizedBox(height: 24),
                _SectionHeader(
                  title: "High Risk Alerts",
                  subtitle: "Immediate attention",
                  color: Colors.orange,
                ),
              ],
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _BatchActionCard extends StatelessWidget {
  final String batchId;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _BatchActionCard({
    required this.batchId,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.account_tree, color: Colors.red),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
