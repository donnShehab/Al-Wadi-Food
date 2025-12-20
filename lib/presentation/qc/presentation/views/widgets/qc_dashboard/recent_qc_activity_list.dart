import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'recent_qc_activity_item.dart';

class RecentQCActivityList extends StatelessWidget {
  final List<QCResultEntity> results;

  const RecentQCActivityList({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent QC Activity',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...results.map((r) => RecentQCActivityItem(result: r)),
      ],
    );
  }
}
