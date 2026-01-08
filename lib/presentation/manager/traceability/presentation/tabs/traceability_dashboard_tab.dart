import 'package:alwadi_food/presentation/manager/traceability/cubit/traceability_cubit.dart';
import 'package:alwadi_food/presentation/manager/traceability/cubit/traceability_state.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_empty_state.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TraceabilityDashboardTab extends StatelessWidget {
  const TraceabilityDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: AppSpacing.paddingMd,
      child: BlocBuilder<TraceabilityCubit, TraceabilityState>(
        builder: (context, state) {
          final dash = state.dashboard;

          if (dash.totalBatches == 0) {
            return TraceEmptyState(
              icon: Icons.analytics_rounded,
              title: "No dashboard data yet",
              subtitle:
                  "Once batches are created and inspected, KPIs will appear here.\nTip: create a few batches, send to QC, and complete inspections.",
              action: OutlinedButton.icon(
                onPressed: () =>
                    context.read<TraceabilityCubit>().loadDashboard(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Refresh KPIs"),
              ),
            );
          }

          Widget kpiCard({
            required String title,
            required String value,
            required IconData icon,
            required Color color,
          }) {
            return Container(
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: color.withOpacity(0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: color, size: 28),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    value,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.bold.copyWith(color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(title, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "KPIs",
                  style: Theme.of(context).textTheme.titleLarge?.bold,
                ),
                const SizedBox(height: AppSpacing.md),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.25,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  children: [
                    kpiCard(
                      title: "Pass Rate",
                      value: "${dash.passRate.toStringAsFixed(1)}%",
                      icon: Icons.percent_rounded,
                      color: Colors.green,
                    ),
                    kpiCard(
                      title: "Failed Batches",
                      value: dash.failedCount.toString(),
                      icon: Icons.error_rounded,
                      color: scheme.error,
                    ),
                    kpiCard(
                      title: "Pending QC",
                      value: dash.waitingQcCount.toString(),
                      icon: Icons.hourglass_bottom_rounded,
                      color: scheme.tertiary,
                    ),
                    kpiCard(
                      title: "Total (recent)",
                      value: dash.totalBatches.toString(),
                      icon: Icons.inventory_2_rounded,
                      color: scheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                Text(
                  "Latest Alerts",
                  style: Theme.of(context).textTheme.titleLarge?.bold,
                ),
                const SizedBox(height: 8),
                if (dash.latestAlerts.isEmpty)
                  Container(
                    padding: AppSpacing.paddingMd,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: scheme.outline.withOpacity(0.18),
                      ),
                    ),
                    child: Text(
                      "No critical alerts found recently.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  )
                else
                  Column(
                    children: dash.latestAlerts.map((a) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: AppSpacing.paddingMd,
                        decoration: BoxDecoration(
                          color: scheme.error.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(
                            color: scheme.error.withOpacity(0.20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.notification_important_rounded,
                              color: scheme.error,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                a,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: AppSpacing.lg),
                Text(
                  "Trends",
                  style: Theme.of(context).textTheme.titleLarge?.bold,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: AppSpacing.paddingLg,
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: scheme.outline.withOpacity(0.18)),
                  ),
                  child: Text(
                    "Trend charts placeholder (weekly pass rate / failures by line).\nWe can connect this to your existing manager dashboard trends later.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          );
        },
      ),
    );
  }
}
