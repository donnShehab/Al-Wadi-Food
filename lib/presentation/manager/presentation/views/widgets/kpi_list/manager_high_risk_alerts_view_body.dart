import 'package:alwadi_food/core/helper_functions/manager_fields_helper.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_kpi_list/manager_kpi_list_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_kpi_list/manager_kpi_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagerHighRiskAlertsViewBody extends StatelessWidget {
  const ManagerHighRiskAlertsViewBody({super.key});

  String _riskLabel(double temp, double moisture) {
    if (temp > 20 || moisture > 25) return "CRITICAL";
    if (temp > 10 || moisture > 15) return "HIGH";
    return "MEDIUM";
  }

  Color _riskColor(String risk) {
    switch (risk) {
      case "CRITICAL":
        return Colors.red;
      case "HIGH":
        return Colors.orange;
      default:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(title: const Text("High Risk Alerts"), centerTitle: true),
      body: BlocBuilder<ManagerKpiListCubit, ManagerKpiListState>(
        builder: (context, state) {
          if (state is ManagerKpiListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ManagerKpiListLoaded) {
            if (state.items.isEmpty) {
              return const Center(child: Text("No high-risk alerts today ✅"));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final alert = state.items[index];

                final name = ManagerFieldsHelper.productName(alert);
                final line = ManagerFieldsHelper.lineName(alert);
                final imageUrl = ManagerFieldsHelper.imageUrl(alert);

                final temp = (alert["temperature"] ?? 0).toDouble();
                final moisture = (alert["moisture"] ?? 0).toDouble();

                final risk = _riskLabel(temp, moisture);
                final riskColor = _riskColor(risk);

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: riskColor.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey.shade100,
                          image: imageUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: imageUrl.isEmpty
                            ? Icon(
                                Icons.warning_amber_rounded,
                                color: riskColor.withOpacity(0.85),
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Line: $line",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Temp: ${temp.toStringAsFixed(1)}°C  |  Moisture: ${moisture.toStringAsFixed(1)}%",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: riskColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: riskColor.withOpacity(0.35),
                          ),
                        ),
                        child: Text(
                          risk,
                          style: TextStyle(
                            color: riskColor,
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

          if (state is ManagerKpiListError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
