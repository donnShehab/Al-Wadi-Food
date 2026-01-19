import 'package:alwadi_food/presentation/animations/pressable_card.dart';
import 'package:alwadi_food/presentation/animations/screen_entry_animation.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_line_comparison_entity.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/reports/reports_lines_comparison_chart.dart';

class ReportsLinesComparisonSection extends StatelessWidget {
  final List<ReportsLineComparisonEntity> lines;
  final ReportsLineComparisonEntity? bestLine;
  final ReportsLineComparisonEntity? worstLine;

  const ReportsLinesComparisonSection({
    super.key,
    required this.lines,
    required this.bestLine,
    required this.worstLine,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ScreenEntryAnimation(
      beginOffset: const Offset(0, 0.15),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [scheme.surface, scheme.surface.withOpacity(0.92)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: scheme.outline.withOpacity(0.14)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // HEADER
            // =====================================================
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: scheme.primary.withOpacity(0.12),
                  ),
                  child: Icon(
                    Icons.insights_rounded,
                    color: scheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Line Performance Overview",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              "High-level comparison between the best and worst performing lines.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface.withOpacity(0.65),
              ),
            ),

            const SizedBox(height: 20),

            // =====================================================
            // KPI HIGHLIGHTS
            // =====================================================
            Row(
              children: [
                if (bestLine != null)
                  Expanded(
                    child: PressableScale(
                      child: _highlightCard(
                        context,
                        title: "Best Line",
                        line: bestLine!,
                        color: Colors.green,
                      ),
                    ),
                  ),
                if (bestLine != null && worstLine != null)
                  const SizedBox(width: 14),
                if (worstLine != null)
                  Expanded(
                    child: PressableScale(
                      child: _highlightCard(
                        context,
                        title: "Worst Line",
                        line: worstLine!,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 26),

            // =====================================================
            // COMPARISON CHART
            // =====================================================
            ReportsLinesComparisonChart(lines: lines),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // HIGHLIGHT CARD
  // =========================================================
  Widget _highlightCard(
    BuildContext context, {
    required String title,
    required ReportsLineComparisonEntity line,
    required Color color,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: scheme.surface.withOpacity(0.96),
        border: Border.all(color: color.withOpacity(0.28)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, color: color, size: 12),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 0.4,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            line.lineName,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          Text(
            "${line.passRate.toStringAsFixed(1)}% Pass Rate",
            style: TextStyle(fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }
}
