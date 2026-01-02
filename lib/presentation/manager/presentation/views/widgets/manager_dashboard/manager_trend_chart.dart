import 'package:alwadi_food/presentation/manager/domain/entities/manager_trend_day_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManagerTrendChart extends StatelessWidget {
  final List<ManagerTrendDayEntity> trend;

  const ManagerTrendChart({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (trend.isEmpty) {
      return const Center(child: Text("No trend data yet"));
    }

    final maxValue = trend
        .map((e) => e.passed > e.failed ? e.passed : e.failed)
        .fold<int>(1, (prev, el) => el > prev ? el : prev);

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: (maxValue + 2).toDouble(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: Colors.grey.withOpacity(0.15), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 34,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= trend.length)
                    return const SizedBox();

                  final day = trend[index].day;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat("E").format(day),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            // ✅ PASS
            LineChartBarData(
              spots: List.generate(
                trend.length,
                (i) => FlSpot(i.toDouble(), trend[i].passed.toDouble()),
              ),
              isCurved: true,
              barWidth: 4,
              color: Colors.green,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withOpacity(0.12),
              ),
            ),
            // ✅ FAIL
            LineChartBarData(
              spots: List.generate(
                trend.length,
                (i) => FlSpot(i.toDouble(), trend[i].failed.toDouble()),
              ),
              isCurved: true,
              barWidth: 4,
              color: Colors.red,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red.withOpacity(0.10),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
      ),
    );
  }
}
