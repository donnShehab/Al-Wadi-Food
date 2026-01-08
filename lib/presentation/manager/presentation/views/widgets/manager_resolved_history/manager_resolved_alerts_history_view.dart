import 'package:alwadi_food/presentation/manager/cubit/manager_resolved_alerts/manager_resolved_alerts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/core/helper_functions/manager_fields_helper.dart';
import 'package:alwadi_food/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

class ManagerResolvedAlertsHistoryView extends StatelessWidget {
  const ManagerResolvedAlertsHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ManagerResolvedAlertsCubit>()..loadResolvedAlerts(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          title: const Text("Resolved Alerts History"),
          centerTitle: true,
        ),
        body:
            BlocBuilder<ManagerResolvedAlertsCubit, ManagerResolvedAlertsState>(
              builder: (context, state) {
                if (state is ManagerResolvedAlertsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ManagerResolvedAlertsError) {
                  return Center(child: Text(state.message));
                }

                if (state is ManagerResolvedAlertsLoaded) {
                  if (state.items.isEmpty) {
                    return const Center(
                      child: Text("No resolved alerts yet ✅"),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = state.items[index];

                      final name = ManagerFieldsHelper.productName(item);
                      final line = ManagerFieldsHelper.lineName(item);
                      final imageUrl = ManagerFieldsHelper.imageUrl(item);
                      final inspectionId = (item["id"] ?? "").toString();

                      final resolvedBy = item["resolvedBy"] ?? "-";
                      final note = item["resolveNote"] ?? "";

                      return InkWell(
                        onTap: () => context.push(
                          "${AppRouter.KQCDetailsView}/$inspectionId",
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
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
                                        width: 55,
                                        height: 55,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: 55,
                                        height: 55,
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
                                        fontSize: 14,
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
                                      "Resolved By: $resolvedBy",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (note.toString().trim().isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          "Note: $note",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
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
                    },
                  );
                }

                return const SizedBox();
              },
            ),
      ),
    );
  }
}
