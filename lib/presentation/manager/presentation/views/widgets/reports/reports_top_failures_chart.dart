import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_failure_reason_entity.dart';

class ReportsTopFailuresChart extends StatelessWidget {
  final List<ReportsFailureReasonEntity> reasons;

  const ReportsTopFailuresChart({super.key, required this.reasons});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (reasons.isEmpty) {
      return _emptyCard(context);
    }

    final total = reasons.fold<int>(0, (sum, item) => sum + item.count);
    final maxVal = reasons.map((e) => e.count).reduce((a, b) => a > b ? a : b);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, anim, _) {
        return Container(
          padding: const EdgeInsets.all(22),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF0A1931).withOpacity(0.06),
                Colors.white.withOpacity(0.92),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: scheme.outline.withOpacity(0.14)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0A1931).withOpacity(0.18),
                blurRadius: 26,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======================================================
              // HEADER
              // ======================================================
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF1768AC).withOpacity(0.12),
                    ),
                    child: const Icon(
                      Icons.bar_chart_rounded,
                      color: Color(0xFF1768AC),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Top Failure Reasons",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  _pill("Total: $total"),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                "Most common reasons for QC failures.",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface.withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 22),

              // ======================================================
              // BAR CHART (ANIMATED HEIGHT)
              // ======================================================
              SizedBox(
                height: 270,
                child: BarChart(
                  BarChartData(
                    maxY: maxVal.toDouble() + 2,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipRoundedRadius: 14,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final item = reasons[groupIndex];
                          final pct = (item.count / total) * 100;

                          return BarTooltipItem(
                            "${item.reason}\n",
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "Count: ${item.count}  •  ${pct.toStringAsFixed(1)}%",
                                style: TextStyle(
                                  color: Colors.amber.shade300,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: const Color(0xFF0A1931).withOpacity(0.08),
                        strokeWidth: 1,
                      ),
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
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 70,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= reasons.length) {
                              return const SizedBox();
                            }

                            String label = _shorten(reasons[index].reason);

                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Transform.rotate(
                                angle: -0.45,
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                    color: scheme.onSurface.withOpacity(0.75),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(reasons.length, (index) {
                      final r = reasons[index];
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: r.count.toDouble() * anim,
                            width: 18,
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFA30015),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxVal.toDouble() + 2,
                              color: const Color(0xFF0A1931).withOpacity(0.12),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ======================================================
              // TABLE (STATIC, EXECUTIVE APPENDIX)
              // ======================================================
              _table(context, total),
            ],
          ),
        );
      },
    );
  }

  // ======================================================
  // UTILITIES
  // ======================================================
  String _shorten(String text) {
    if (text.length <= 12) return text;
    return text.substring(0, 10) + "…";
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1768AC).withOpacity(0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF1768AC).withOpacity(0.28)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1768AC),
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _emptyCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: scheme.surface,
        border: Border.all(color: const Color(0xFF2E8B57).withOpacity(0.30)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: Color(0xFF2E8B57)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "No failure reasons detected in this range.",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _table(BuildContext context, int total) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outline.withOpacity(0.16)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Reason",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(
                width: 60,
                child: Text("%", textAlign: TextAlign.center),
              ),
              const SizedBox(
                width: 50,
                child: Text("Count", textAlign: TextAlign.end),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: scheme.outline.withOpacity(0.14)),
          const SizedBox(height: 12),
          ...reasons.map((r) {
            final pct = (r.count / total) * 100;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      r.reason,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      "${pct.toStringAsFixed(1)}%",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1768AC),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      "${r.count}",
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFA30015),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
