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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    "Line Performance Overview",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "High-level comparison between the best and worst performing lines.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                if (bestLine != null)
                  Expanded(
                    child: PressableScale(
                      onTap: () {}, // UI-only tactile
                      child: _highlightCard(
                        context,
                        title: "Best Line",
                        line: bestLine!,
                        color: const Color(0xFF2E8B57),
                      ),
                    ),
                  ),
                if (bestLine != null && worstLine != null)
                  const SizedBox(width: 12),
                if (worstLine != null)
                  Expanded(
                    child: PressableScale(
                      onTap: () {}, // UI-only tactile
                      child: _highlightCard(
                        context,
                        title: "Worst Line",
                        line: worstLine!,
                        color: const Color(0xFFA30015),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            ReportsLinesComparisonChart(lines: lines),
          ],
        ),
      ),
    );
  }

  Widget _highlightCard(
    BuildContext context, {
    required String title,
    required ReportsLineComparisonEntity line,
    required Color color,
  }) {
    final t = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withOpacity(0.07),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    letterSpacing: 0.3,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            line.lineName,
            style: t.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.black87,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            "${line.passRate.toStringAsFixed(1)}% Pass Rate",
            style: t.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
