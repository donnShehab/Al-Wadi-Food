import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_trend_day_entity.dart';

class QCAnalyticsKPIRow extends StatelessWidget {
  final List<QCTrendDayEntity> trend;

  const QCAnalyticsKPIRow({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final totalPass = trend.fold<int>(0, (sum, d) => sum + d.passed);
    final totalFail = trend.fold<int>(0, (sum, d) => sum + d.failed);
    final total = totalPass + totalFail;

    final passRate = total == 0 ? 0 : ((totalPass / total) * 100).round();

    return Row(
      children: [
        _kpiCard(
          theme,
          title: "Total Pass",
          value: totalPass.toString(),
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        const SizedBox(width: 12),
        _kpiCard(
          theme,
          title: "Total Fail",
          value: totalFail.toString(),
          icon: Icons.cancel,
          color: Colors.red,
        ),
        const SizedBox(width: 12),
        _kpiCard(
          theme,
          title: "Pass Rate",
          value: "$passRate%",
          icon: Icons.analytics,
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _kpiCard(
    ThemeData theme, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 10),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
