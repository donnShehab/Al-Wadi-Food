import 'package:alwadi_food/theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProductionBarChart extends StatelessWidget {
  final Map<String, int> lines;

  const ProductionBarChart({super.key, required this.lines});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: lines.entries.map((e) {
            final index = lines.keys.toList().indexOf(e.key);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: e.value.toDouble(),
                  color: LightModeColors.lightSecondary,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
