import 'package:alwadi_food/presentation/manager/domain/entities/manager_trend_day_entity.dart';
import 'package:flutter/material.dart';
import 'manager_trend_chart.dart';
import 'manager_trend_summary_row.dart';

class ManagerTrendSection extends StatelessWidget {
  final List<ManagerTrendDayEntity> trend;

  const ManagerTrendSection({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
            "QC Weekly Trend",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "PASS vs FAIL in last 7 days",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),

          /// ✅ Chart
          ManagerTrendChart(trend: trend),

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

          const SizedBox(height: 18),

          /// ✅ NEW: Summary chips + Insights row
          ManagerTrendSummaryRow(trend: trend),
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
