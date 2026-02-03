import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/recent_qc_activity_list.dart';
import 'package:flutter/material.dart';

class QCRecentActivitySection extends StatelessWidget {
  final List<QCResultEntity> recentResults;

  const QCRecentActivitySection({super.key, required this.recentResults});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (recentResults.isEmpty) {
      // UI-only: premium empty state
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.08),
          ),
          color: theme.colorScheme.surface,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history,
                color: theme.colorScheme.primary.withOpacity(0.85),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "No recent QC activity yet.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.85),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RecentQCActivityList(results: recentResults);
  }
}
