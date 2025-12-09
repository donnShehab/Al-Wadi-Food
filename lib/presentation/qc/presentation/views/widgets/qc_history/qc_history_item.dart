import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/core/utils/date_formatter.dart';

class QCHistoryItem extends StatelessWidget {
  final QCResultEntity result;

  const QCHistoryItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inspector: ${result.inspectorName}',
                  style: theme.textTheme.titleMedium?.semiBold,
                ),
                Chip(
                  label: Text(
                    result.result.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: result.result == 'pass'
                      ? LightModeColors.lightSuccess
                      : LightModeColors.lightError,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text('Date: ${DateFormatter.formatDateTime(result.createdAt)}'),
            Text('Temperature: ${result.temperature}°C'),
            Text('Weight: ${result.weight}kg'),
            Text('Notes: ${result.notes}'),
            if (result.failureReason != null)
              Text(
                'Failure Reason: ${result.failureReason}',
                style: TextStyle(color: LightModeColors.lightError),
              ),
          ],
        ),
      ),
    );
  }
}
