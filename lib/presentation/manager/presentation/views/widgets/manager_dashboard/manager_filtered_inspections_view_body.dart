import 'package:alwadi_food/presentation/manager/cubit/manager_dashboard/manager_filtered_inspections_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_dashboard/manager_filtered_inspections_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/core/helper_functions/manager_fields_helper.dart';

class ManagerFilteredInspectionsViewBody extends StatelessWidget {
  final String title;
  final String filterType;
  final String filterValue;

  const ManagerFilteredInspectionsViewBody({
    super.key,
    required this.title,
    required this.filterType,
    required this.filterValue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(title: Text(title), centerTitle: true),
      body:
          BlocBuilder<
            ManagerFilteredInspectionsCubit,
            ManagerFilteredInspectionsState
          >(
            builder: (context, state) {
              if (state is ManagerFilteredInspectionsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ManagerFilteredInspectionsLoaded) {
                if (state.items.isEmpty) {
                  return Center(child: Text("No results for $filterValue"));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final i = state.items[index];

                    final name = ManagerFieldsHelper.productName(i);
                    final imageUrl = ManagerFieldsHelper.imageUrl(i);
                    final line = ManagerFieldsHelper.lineName(i);

                    final inspector =
                        (i["inspectorName"] ?? i["inspector"] ?? "Unknown")
                            .toString();

                    final result = (i["result"] ?? i["qcResult"] ?? "-")
                        .toString();

                    final temp = (i["temperature"] ?? 0).toDouble();
                    final moisture = (i["moisture"] ?? 0).toDouble();

                    final isFail = result.toLowerCase().contains("fail");

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 56,
                                    height: 56,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.fastfood),
                                  ),
                          ),
                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Inspector: $inspector",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Line: $line",
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Temp: ${temp.toStringAsFixed(1)}°C | Moisture: ${moisture.toStringAsFixed(1)}%",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: isFail
                                  ? Colors.red.withOpacity(0.10)
                                  : Colors.green.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isFail
                                    ? Colors.red.withOpacity(0.25)
                                    : Colors.green.withOpacity(0.25),
                              ),
                            ),
                            child: Text(
                              isFail ? "FAIL" : "PASS",
                              style: TextStyle(
                                color: isFail ? Colors.red : Colors.green,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              if (state is ManagerFilteredInspectionsError) {
                return Center(child: Text(state.message));
              }

              return const SizedBox();
            },
          ),
    );
  }
}
