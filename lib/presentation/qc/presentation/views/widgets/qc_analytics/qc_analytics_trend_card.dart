import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_trend_dashboard/qc_trend_chart.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_trend_day_entity.dart';

class QCAnalyticsTrendCard extends StatelessWidget {
  final List<QCTrendDayEntity> trend;

  const QCAnalyticsTrendCard({super.key, required this.trend});

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
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          QCTrendChart(trend: trend),
          const SizedBox(height: 12),

          // ✅ Chart legend (للمدير)
          Row(
            children: [
              _legendDot(Colors.green),
              const SizedBox(width: 6),
              Text(
                "Pass",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 14),
              _legendDot(Colors.red),
              const SizedBox(width: 6),
              Text(
                "Fail",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color c) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: c, shape: BoxShape.circle),
    );
  }
}
