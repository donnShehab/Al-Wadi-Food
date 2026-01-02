import 'package:alwadi_food/core/helper_functions/manager_fields_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_kpi_list/manager_kpi_list_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_kpi_list/manager_kpi_list_state.dart';

class ManagerProductionTodayViewBody extends StatelessWidget {
  const ManagerProductionTodayViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("Production Today"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<ManagerKpiListCubit, ManagerKpiListState>(
        builder: (context, state) {
          if (state is ManagerKpiListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ManagerKpiListLoaded) {
            if (state.items.isEmpty) {
              return const Center(
                child: Text(
                  "No batches today",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final b = state.items[index];

                final productName = ManagerFieldsHelper.productName(b);
                final line = b["line"] ?? "-";
                final qty = b["quantity"] ?? 0;
                final status = b["status"] ?? "-";

                final images = (b["images"] as List?)?.cast<String>();
                final imageUrl = (images != null && images.isNotEmpty)
                    ? images.first
                    : null;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
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
                      /// ✅ Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 52,
                                height: 52,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.fastfood,
                                  color: Colors.grey,
                                ),
                              ),
                      ),

                      const SizedBox(width: 14),

                      /// ✅ Product Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Line: $line  |  Qty: $qty",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// ✅ Status Badge
                      _StatusBadge(status: status),
                    ],
                  ),
                );
              },
            );
          }

          if (state is ManagerKpiListError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

/// ✅ Status badge widget
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final s = status.toLowerCase();

    Color bg = Colors.grey.withOpacity(0.12);
    Color fg = Colors.grey;

    if (s.contains("passed")) {
      bg = Colors.green.withOpacity(0.12);
      fg = Colors.green;
    } else if (s.contains("failed")) {
      bg = Colors.red.withOpacity(0.12);
      fg = Colors.red;
    } else if (s.contains("waiting")) {
      bg = Colors.orange.withOpacity(0.12);
      fg = Colors.orange;
    } else if (s.contains("in_progress")) {
      bg = Colors.blue.withOpacity(0.12);
      fg = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withOpacity(0.35)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
