import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/manager_dashboard_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManagerInsightsSection extends StatelessWidget {
  final ManagerDashboardEntity data;

  const ManagerInsightsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Smart Insights",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),

          _tile(
            context,
            icon: Icons.trending_down,
            title: "Worst Line Today",
            value: data.worstLineToday,
            onTap: () => context.push(
              AppRouter.KManagerFilteredInspectionsView,
              extra: {
                "title": "Worst Line Today",
                "filterType": "line",
                "filterValue": data.worstLineToday,
              },
            ),
          ),

          _tile(
            context,
            icon: Icons.trending_up,
            title: "Best Line Today",
            value: data.bestLineToday,
            onTap: () => context.push(
              AppRouter.KManagerFilteredInspectionsView,
              extra: {
                "title": "Best Line Today",
                "filterType": "line",
                "filterValue": data.bestLineToday,
              },
            ),
          ),

          _tile(
            context,
            icon: Icons.report_problem,
            title: "Most Repeated Failure",
            value: data.mostRepeatedFailure,
            onTap: () => context.push(
              AppRouter.KManagerFilteredInspectionsView,
              extra: {
                "title": "Failure Reason",
                "filterType": "failureReason",
                "filterValue": data.mostRepeatedFailure,
              },
            ),
          ),

          _tile(
            context,
            icon: Icons.emoji_events,
            title: "Top QC Inspector",
            value: data.bestInspector,
            onTap: () => context.push(
              AppRouter.KManagerFilteredInspectionsView,
              extra: {
                "title": "Top QC Inspector",
                "filterType": "inspectorName",
                "filterValue": data.bestInspector,
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: value.trim().isEmpty || value == "-" ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),

            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}
