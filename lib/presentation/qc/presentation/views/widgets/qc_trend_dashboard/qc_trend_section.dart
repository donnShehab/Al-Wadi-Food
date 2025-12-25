import 'package:alwadi_food/presentation/qc/domain/entites/qc_trend_day_entity.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'qc_trend_chart.dart';

class QCTrendSection extends StatelessWidget {
  final List<QCTrendDayEntity> trend;

  const QCTrendSection({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "QC Trend Analytics",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Weekly quality trend monitoring (Last 7 Days)",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

          QCTrendChart(trend: trend),

          const SizedBox(height: 12),

          /// ✅ Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(color: Colors.green, label: "PASS"),
              const SizedBox(width: 18),
              _legendDot(color: Colors.red, label: "FAIL"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ],
    );
  }
}
