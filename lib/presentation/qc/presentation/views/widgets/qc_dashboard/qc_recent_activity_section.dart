import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/recent_qc_activity_list.dart';
import 'package:flutter/material.dart';

class QCRecentActivitySection extends StatelessWidget {
  final List<QCResultEntity> recentResults;

  const QCRecentActivitySection({super.key, required this.recentResults});

  @override
  Widget build(BuildContext context) {
    if (recentResults.isEmpty) {
      return Text(
        "No recent QC activity yet.",
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return RecentQCActivityList(results: recentResults);
  }
}
