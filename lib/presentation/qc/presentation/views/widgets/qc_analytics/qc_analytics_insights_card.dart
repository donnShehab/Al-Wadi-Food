import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_trend_day_entity.dart';

class QCAnalyticsInsightsCard extends StatelessWidget {
  final List<QCTrendDayEntity> trend;

  const QCAnalyticsInsightsCard({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (trend.isEmpty) {
      return const SizedBox();
    }

    /// ✅ Best Day = max passed
    final bestDay = trend.reduce((a, b) => a.passed > b.passed ? a : b);

    /// ✅ Worst Day = max failed
    final worstDay = trend.reduce((a, b) => a.failed > b.failed ? a : b);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Weekly Insights",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          _row(
            icon: Icons.star,
            title: "Best Quality Day",
            value: "${bestDay.passed} Passed",
            color: Colors.green,
          ),
          const SizedBox(height: 10),

          _row(
            icon: Icons.warning_amber,
            title: "Highest Failure Day",
            value: "${worstDay.failed} Failed",
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _row({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
