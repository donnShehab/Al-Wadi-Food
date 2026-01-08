import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_line_comparison_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_worst_line_insight_entity.dart';

class ReportsWorstLineInsightSection extends StatelessWidget {
  final ReportsWorstLineInsightEntity? worstInsight;
  final ReportsLineComparisonEntity? bestLine;

  const ReportsWorstLineInsightSection({
    super.key,
    required this.worstInsight,
    required this.bestLine,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (worstInsight == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.outline.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: scheme.onSurfaceVariant),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "No insight available for this range.",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      );
    }

    final w = worstInsight!;
    final gap = bestLine == null
        ? null
        : (bestLine!.passRate - w.passRate).abs();

    final narrative = _buildNarrative(w, bestLine);
    final actions = _recommendedActions(w);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.redAccent.withOpacity(0.18)),
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
              const Icon(Icons.trending_down_rounded, color: Colors.redAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Worst Line Insight",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              _badge("HIGH", Colors.redAccent),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            w.lineName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),

          const SizedBox(height: 14),

          // ✅ Stats Row
          Row(
            children: [
              _statCard(
                context,
                "Pass Rate",
                "${w.passRate.toStringAsFixed(1)}%",
                Colors.green,
              ),
              const SizedBox(width: 10),
              _statCard(context, "Failed", "${w.failed}", Colors.redAccent),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _statCard(context, "High Risk", "${w.highRisk}", Colors.orange),
              const SizedBox(width: 10),
              _statCard(context, "Total", "${w.total}", scheme.primary),
            ],
          ),

          const SizedBox(height: 18),

          // ✅ Narrative
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.redAccent.withOpacity(0.14)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.psychology_alt_rounded,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    narrative,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ✅ Reasons
          Text(
            "Top Failure Reasons",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),

          if (w.topReasons.isEmpty)
            Text(
              "No failure reasons recorded.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            )
          else
            ...w.topReasons.map((r) => _reasonRow(context, r)),

          const SizedBox(height: 18),

          // ✅ Recommended Actions
          Text(
            "Recommended Actions",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),

          ...actions.map((a) => _actionRow(context, a)),

          const SizedBox(height: 18),

          // ✅ CAPA Workflow Card
          _capaCard(context),

          const SizedBox(height: 18),

          // ✅ Compare to best line
          if (bestLine != null) ...[
            Divider(color: scheme.outline.withOpacity(0.12)),
            const SizedBox(height: 12),

            Text(
              "Compared to Best Line",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              "✅ Best: ${bestLine!.lineName} (${bestLine!.passRate.toStringAsFixed(1)}%)",
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.green,
              ),
            ),
            Text(
              "❌ Worst: ${w.lineName} (${w.passRate.toStringAsFixed(1)}%)",
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.redAccent,
              ),
            ),
            if (gap != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  "Gap: ${gap.toStringAsFixed(1)}% difference",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ✅ CAPA Card
  Widget _capaCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withOpacity(0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment_rounded, color: scheme.primary),
              const SizedBox(width: 8),
              Text(
                "Corrective Action Plan (CAPA)",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Owner: QC Manager",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            "Deadline: 3 Days",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            "Status: OPEN",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 14),

          // ✅ Progress
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: 0.25,
              minHeight: 10,
              backgroundColor: scheme.surfaceContainerHighest.withOpacity(0.4),
              valueColor: AlwaysStoppedAnimation(scheme.primary),
            ),
          ),

          const SizedBox(height: 10),
          Text(
            "Progress indicator based on pass rate improvement.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reasonRow(BuildContext context, Map r) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withOpacity(0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outline.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              r["reason"].toString(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _badge(r["count"].toString(), Colors.redAccent),
        ],
      ),
    );
  }

  Widget _actionRow(BuildContext context, String text) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: scheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
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

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildNarrative(
    ReportsWorstLineInsightEntity w,
    ReportsLineComparisonEntity? bestLine,
  ) {
    final reasonsText = w.topReasons.isEmpty
        ? "No clear failure reasons were recorded."
        : "Top issues: ${w.topReasons.map((e) => e["reason"]).take(2).join(", ")}.";

    if (bestLine == null) {
      return "This line has the lowest performance in the selected range. $reasonsText High risk alerts suggest process instability.";
    }

    final gap = (bestLine.passRate - w.passRate).toStringAsFixed(1);
    return "This line is performing lower than the best line by ($gap%). $reasonsText This suggests recurring operational issues that must be prioritized.";
  }

  List<String> _recommendedActions(ReportsWorstLineInsightEntity w) {
    final actions = <String>[
      "Investigate the top failure reason and implement a checklist fix.",
      "Review temperature / moisture logs for abnormal patterns.",
      "Perform quick maintenance audit on this production line.",
    ];

    if (w.highRisk > 0) {
      actions.add(
        "High risk alerts detected: recalibrate sensors and tighten QC thresholds.",
      );
    }

    if (w.failed >= 3) {
      actions.add(
        "Repeated failures: create a CAPA plan with supervisors and track progress daily.",
      );
    }

    return actions;
  }
}
