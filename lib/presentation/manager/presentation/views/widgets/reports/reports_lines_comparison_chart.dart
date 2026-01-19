import 'package:alwadi_food/presentation/manager/domain/entities/reports_line_comparison_entity.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportsLinesComparisonChart extends StatelessWidget {
  final List<ReportsLineComparisonEntity> lines;

  const ReportsLinesComparisonChart({super.key, required this.lines});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (lines.isEmpty) {
      return _emptyCard(context, "No Line Data Available");
    }

    final visible = lines.take(7).toList();

    return _container(
      context,
      title: "Pass Rate Comparison Across Production Lines",
      subtitle: "",
      child: SizedBox(
        height: 320,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            barTouchData: BarTouchData(enabled: true),

            // -------------------------------------------
            // GRID STYLE (Muted corporate tone)
            // -------------------------------------------
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) => FlLine(
                color: const Color(0xFF0A1931).withOpacity(0.08),
                strokeWidth: 1,
              ),
            ),

            borderData: FlBorderData(show: false),

            // -------------------------------------------
            // TITLES — FIXED LABEL VISIBILITY
            // -------------------------------------------
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              // Y-axis values
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 38,
                  getTitlesWidget: (value, _) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface.withOpacity(0.65),
                      ),
                    ),
                  ),
                ),
              ),

              // X-axis line labels (FIXED HERE)
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 70, // <-- FIXED
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= visible.length) {
                      return const SizedBox();
                    }

                    final name = visible[index].lineName;

                    // SAFE SHORT LABEL
                    final short = _shortenName(name);

                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Transform.rotate(
                        angle: -0.5, // -30° angle
                        child: Text(
                          short,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface.withOpacity(0.75),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // -------------------------------------------
            // BARS (CORPORATE COLOR THEME B)
            // -------------------------------------------
            barGroups: List.generate(visible.length, (index) {
              final item = visible[index];

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: item.passRate,
                    width: 20,
                    borderRadius: BorderRadius.circular(8),

                    // Teal corporate color
                    color: const Color(0xFF1768AC),

                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 100,
                      color: const Color(0xFF0A1931).withOpacity(0.10),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // Safe label shortener (fix long names)
  // ---------------------------------------------------------
  String _shortenName(String name) {
    if (name.length <= 8) return name;

    // Example: “Production Line 7” → “PL7”
    final parts = name.split(" ");
    if (parts.length >= 2) {
      final first = parts[0][0].toUpperCase();
      final last = parts.last.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
      return "$first$last";
    }

    // General fallback
    return name.substring(0, 6) + "…";
  }

  // ---------------------------------------------------------
  // CONTAINER WRAPPER
  // ---------------------------------------------------------
  Widget _container(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: scheme.surface,
        border: Border.all(color: scheme.outline.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A1931).withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: scheme.onSurface.withOpacity(0.65),
              ),
            ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _emptyCard(BuildContext context, String msg) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.surface,
        border: Border.all(color: scheme.outline.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_rounded, color: const Color(0xFF1768AC)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              msg,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
