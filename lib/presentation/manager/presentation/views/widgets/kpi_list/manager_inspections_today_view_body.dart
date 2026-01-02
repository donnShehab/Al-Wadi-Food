import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/core/helper_functions/manager_fields_helper.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_kpi_list/manager_kpi_list_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_kpi_list/manager_kpi_list_state.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_dashboard/manager_list_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagerInspectionsTodayViewBody extends StatelessWidget {
  const ManagerInspectionsTodayViewBody({super.key});

  bool _isPassed(Map<String, dynamic> data) {
    final result = (data["result"] ?? data["qcResult"] ?? "").toString();
    if (result == AppConstants.qcResultPass) return true;

    final passedBool = data["passed"];
    if (passedBool is bool) return passedBool;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("QC Inspections Today"),
        centerTitle: true,
      ),
      body: BlocBuilder<ManagerKpiListCubit, ManagerKpiListState>(
        builder: (context, state) {
          if (state is ManagerKpiListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ManagerKpiListLoaded) {
            if (state.items.isEmpty) {
              return const Center(child: Text("No inspections today"));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final i = state.items[index];
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
                final name = ManagerFieldsHelper.productName(i);
                final inspector =
                    (i["inspectorName"] ?? i["inspector"] ?? "Unknown")
                        .toString();
                final imageUrl = ManagerFieldsHelper.imageUrl(i);
                final asset = ManagerFieldsHelper.imageUrl(i);

                final passed = _isPassed(i);
              
                return ManagerListItemCard(
                  title: name,
                  subtitle: "Inspector: $inspector",
                  statusText: passed ? "PASS" : "FAIL",
                  statusColor: passed ? Colors.green : Colors.red,
                  imageUrl: imageUrl,
                  onTap: () {
                    // ✅ لاحقاً: تفتح QC Details view
                  },
                  assetPath: asset,
                );
              },
            );
          }

          if (state is ManagerKpiListError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
