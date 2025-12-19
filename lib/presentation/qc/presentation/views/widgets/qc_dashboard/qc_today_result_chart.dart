import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';

class QCTodayResultChart extends StatelessWidget {
  final int passed;
  final int failed;

  const QCTodayResultChart({
    super.key,
    required this.passed,
    required this.failed,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = (passed > failed ? passed : failed).clamp(1, 999);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QC Results Today',
          style: Theme.of(context).textTheme.titleMedium?.semiBold,
        ),
        const SizedBox(height: AppSpacing.md),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _bar(
              label: 'Passed',
              value: passed,
              maxValue: maxValue,
              color: Colors.green,
            ),
            const SizedBox(width: 24),
            _bar(
              label: 'Failed',
              value: failed,
              maxValue: maxValue,
              color: Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _bar({
    required String label,
    required int value,
    required int maxValue,
    required Color color,
  }) {
    final heightFactor = value / maxValue;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 140 * heightFactor,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}
