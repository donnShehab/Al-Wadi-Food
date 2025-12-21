import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';

class QCDetailsDecisionCard extends StatelessWidget {
  final QCResultEntity result;

  const QCDetailsDecisionCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    if (result.failureReason == null) return const SizedBox();

    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: LightModeColors.lightError.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Failure Reason',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: LightModeColors.lightError,
            ),
          ),
          const SizedBox(height: 8),
          Text(result.failureReason!),
        ],
      ),
    );
  }
}
