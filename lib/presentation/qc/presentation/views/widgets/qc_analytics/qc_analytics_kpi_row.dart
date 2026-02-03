import 'package:alwadi_food/presentation/qc/domain/entites/qc_trend_day_entity.dart';
import 'package:flutter/material.dart';

class QCAnalyticsKPIRow extends StatelessWidget {
  final List<QCTrendDayEntity> trend;

  const QCAnalyticsKPIRow({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final totalPassed = trend.fold<int>(0, (sum, d) => sum + d.passed);
    final totalFailed = trend.fold<int>(0, (sum, d) => sum + d.failed);
    final total = totalPassed + totalFailed;
    final passRate = total == 0 ? 0 : ((totalPassed / total) * 100).round();

    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            title: "Total Pass",
            value: totalPassed.toString(),
            icon: Icons.check_circle_rounded,
            accent: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            title: "Total Fail",
            value: totalFailed.toString(),
            icon: Icons.cancel_rounded,
            accent: Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            title: "Pass Rate",
            value: "$passRate%",
            icon: Icons.bar_chart_rounded,
            accent: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final outline = theme.colorScheme.onSurface.withOpacity(0.06);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.lerp(surface, Colors.white, 0.10) ?? surface, surface],
        ),
        border: Border.all(color: outline, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: accent.withOpacity(0.12),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
