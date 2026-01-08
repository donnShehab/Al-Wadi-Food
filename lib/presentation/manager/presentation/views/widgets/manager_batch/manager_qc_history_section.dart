import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_history/manager_batch_qc_history_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_history/manager_batch_qc_history_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:alwadi_food/theme.dart';

class ManagerQcHistorySection extends StatelessWidget {
  final String batchId;
  const ManagerQcHistorySection({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagerBatchQcHistoryCubit, ManagerBatchQcHistoryState>(
      builder: (context, state) {
        if (state is ManagerBatchQcHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ManagerBatchQcHistoryError) {
          return Text(state.message);
        }

        if (state is ManagerBatchQcHistoryLoaded) {
          final history = state.history;

          return Container(
            padding: AppSpacing.paddingMd,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history_rounded),
                    const SizedBox(width: 8),
                    Text(
                      "QC History",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.push('/qc-history/$batchId'),
                      child: const Text("View All"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (history.isEmpty)
                  Text(
                    "No QC inspections yet ✅",
                    style: TextStyle(color: Colors.grey.shade600),
                  )
                else
                  Column(
                    children: history.take(3).map((item) {
                      final result = (item["result"] ?? "").toString();
                      final isPass = result == AppConstants.qcResultPass;

                      final inspector = (item["inspectorName"] ?? "Unknown")
                          .toString();
                     final createdAtRaw = item["createdAt"];
                      final createdAt = createdAtRaw is Timestamp
                          ? createdAtRaw.toDate()
                          : DateTime.now();

                      final temp = (item["temperature"] ?? 0).toDouble();
                      final moisture = (item["moisture"] ?? 0).toDouble();

                      return InkWell(
                        onTap: () {
                          context.push(
                            "${AppRouter.KQCDetailsView}/${item["id"]}",
                          );

                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isPass
                                ? Colors.green.withOpacity(0.06)
                                : Colors.red.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isPass
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: isPass
                                    ? Colors.green.withOpacity(0.15)
                                    : Colors.red.withOpacity(0.15),
                                child: Icon(
                                  isPass ? Icons.check : Icons.close,
                                  color: isPass ? Colors.green : Colors.red,
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      inspector,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${createdAt.day}/${createdAt.month} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, "0")} • Temp $temp°C • Moist $moisture%",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    if (!isPass &&
                                        (item["failureReason"] ?? "")
                                            .toString()
                                            .isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          "Reason: ${item["failureReason"]}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
