import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_report_entity.dart';
import 'qc_report_tile.dart';

class RecentReportsList extends StatelessWidget {
  final List<QCReportEntity> reports;

  const RecentReportsList({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent Reports",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        if (reports.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "No reports generated yet.",
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )
        else
          ...reports.map((r) => QCReportTile(report: r)),
      ],
    );
  }
}
