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

    final totalFailures = reasons.fold<int>(0, (sum, item) => sum + item.count);

    final max = reasons.map((e) => e.count).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outline.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Header
          Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: scheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Top Failure Reasons",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              _pill(context, "Total: $totalFailures", scheme.primary),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            "Most common causes that triggered QC failures in this range.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withOpacity(0.65),
            ),
          ),

          const SizedBox(height: 18),

          // ✅ Horizontal Chart
          SizedBox(
            height: 240,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: max.toDouble() + 2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 12,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final item = reasons[groupIndex];
                      final pct = ((item.count / totalFailures) * 100);
                      return BarTooltipItem(
                        "${item.reason}\n",
                        const TextStyle(fontWeight: FontWeight.w900),
                        children: [
                          TextSpan(
                            text:
                                "Count: ${item.count}  |  ${pct.toStringAsFixed(1)}%",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: scheme.primary,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
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
                      reservedSize: 34,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: scheme.onSurface.withOpacity(0.55),
                              ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= reasons.length) {
                          return const SizedBox();
                        }
                        final label = reasons[index].reason;
                        final short = label.length > 10
                            ? "${label.substring(0, 10)}…"
                            : label;

                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            short,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onSurface.withOpacity(0.7),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: scheme.outline.withOpacity(0.08),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: reasons.asMap().entries.map((entry) {
                  final index = entry.key;
                  final r = entry.value;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: r.count.toDouble(),
                        width: 18,
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.redAccent,
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: max.toDouble() + 2,
                          color: scheme.surfaceContainerHighest.withOpacity(
                            0.35,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // ✅ Table
          _table(context, totalFailures),

          const SizedBox(height: 16),

          // ✅ Insight
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: scheme.primary.withOpacity(0.16)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_rounded, color: scheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Fixing the top 1 reason can reduce failures by ~${_estimatedImpact(reasons, totalFailures)}% quickly.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _table(BuildContext context, int total) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withOpacity(0.12)),
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
              Text(
                "%",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Count",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: scheme.outline.withOpacity(0.12)),
          const SizedBox(height: 10),
          ...reasons.map((r) {
            final pct = (r.count / total) * 100;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      r.reason,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "${pct.toStringAsFixed(1)}%",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _countChip(r.count),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _countChip(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withOpacity(0.18)),
      ),
      child: Text(
        "$count",
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: Colors.redAccent,
        ),
      ),
    );
  }

  Widget _pill(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 11,
          color: color,
        ),
      ),
    );
  }

  Widget _emptyCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.green.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.verified_rounded, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "✅ No failure reasons found in this range.",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  int _estimatedImpact(List<ReportsFailureReasonEntity> reasons, int total) {
    if (reasons.isEmpty) return 0;
    final top = reasons.first.count;
    return ((top / total) * 100).round();
  }
}
