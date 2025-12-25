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
    final theme = Theme.of(context);
    final maxValue = (passed > failed ? passed : failed).clamp(1, 999);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "QC Results Today",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              _bar(
                label: "Passed",
                value: passed,
                maxValue: maxValue,
                color: Colors.green,
              ),
              const SizedBox(width: 20),
              _bar(
                label: "Failed",
                value: failed,
                maxValue: maxValue,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bar({
    required String label,
    required int value,
    required int maxValue,
    required Color color,
  }) {
    final rawHeight = (value / maxValue) * 120;
    final safeHeight = rawHeight < 14 ? 14.0 : rawHeight; // ✅ Minimum Height

    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
            height: safeHeight,
            decoration: BoxDecoration(
              color: color.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 10),
          Text("$value", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}
