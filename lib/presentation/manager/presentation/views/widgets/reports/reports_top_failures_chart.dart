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

    // Executive insight (UI-only): how concentrated are failures?
    final top3 = reasons.take(3).fold<int>(0, (s, r) => s + r.count);
    final top3Pct = total == 0 ? 0.0 : (top3 / total) * 100;

    final danger = const Color(0xFFB00020); // softer executive red

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: _executiveCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // HEADER
          // ======================================================
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: scheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Top Failure Reasons",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                    color: Colors.black87,
                  ),
                ),
              ),
              _pill(text: "Total $total", tint: scheme.primary),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            "Most common reasons for QC failures (executive view).",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withOpacity(0.65),
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: scheme.primary.withOpacity(0.14)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_rounded, color: scheme.primary, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Top 3 reasons account for ${top3Pct.toStringAsFixed(1)}% of failures.",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ======================================================
          // BAR CHART (CLEAN / EXECUTIVE)
          // ======================================================
          SizedBox(
            height: 260,
            child: BarChart(
              BarChartData(
                maxY: maxVal.toDouble() + 2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 14,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = reasons[groupIndex];
                      final pct = total == 0 ? 0.0 : (item.count / total) * 100;

                      return BarTooltipItem(
                        "${item.reason}\n",
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "Count: ${item.count} • ${pct.toStringAsFixed(1)}%",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
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
                    color: Colors.black.withOpacity(0.06),
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
                      interval: 2,
                      getTitlesWidget: (value, _) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
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

                        final label = _shorten(reasons[index].reason);

                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Transform.rotate(
                            angle: -0.45,
                            child: Text(
                              label,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                color: scheme.onSurface.withOpacity(0.72),
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
                        toY: r.count.toDouble(),
                        width: 18,
                        borderRadius: BorderRadius.circular(10),
                        color: danger.withOpacity(0.90),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxVal.toDouble() + 2,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // TABLE (EXECUTIVE APPENDIX)
          // ======================================================
          _table(context, total, danger),
        ],
      ),
    );
  }

  String _shorten(String text) {
    if (text.length <= 12) return text;
    return text.substring(0, 10) + "…";
  }

  Widget _pill({required String text, required Color tint}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: tint.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tint.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: tint,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _emptyCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: _executiveCardDecoration(),
      child: Row(
        children: [
          Icon(Icons.verified_rounded, color: scheme.primary),
          const SizedBox(width: 10),
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

  Widget _table(BuildContext context, int total, Color danger) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
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
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(
                width: 60,
                child: Text(
                  "%",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(
                width: 50,
                child: Text(
                  "Count",
                  textAlign: TextAlign.end,
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.black.withOpacity(0.06)),
          const SizedBox(height: 8),
          ...reasons.map((r) {
            final pct = total == 0 ? 0.0 : (r.count / total) * 100;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      r.reason,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      "${pct.toStringAsFixed(1)}%",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      "${r.count}",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: danger,
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

BoxDecoration _executiveCardDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(22),
    color: Colors.white.withOpacity(0.96),
    border: Border.all(color: Colors.black.withOpacity(0.05)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 26,
        offset: const Offset(0, 16),
      ),
    ],
  );
}
