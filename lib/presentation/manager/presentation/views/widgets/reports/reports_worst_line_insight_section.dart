import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_line_comparison_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_worst_line_insight_entity.dart';

/// Executive / Manager-friendly insight block.
///
/// NOTE: UI-only refinement. All computations and helper methods are preserved.
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

    // EMPTY STATE
    if (worstInsight == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: _executiveCardDecoration(),
        child: Row(
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
                Icons.info_outline_rounded,
                color: scheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
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

    // UI-only semantic accents (kept soft).
    final danger = const Color(0xFFB00020);
    final warning = const Color(0xFFFF8F00);
    final good = const Color(0xFF2E8B57);

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
                  color: danger.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: danger.withOpacity(0.16)),
                ),
                child: Icon(
                  Icons.trending_down_rounded,
                  color: danger,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Worst Line Insight",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                    color: Colors.black87,
                  ),
                ),
              ),
              _badge("CRITICAL", danger),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            "Focused analysis with a clear action plan for management.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.65),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          // ======================================================
          // LINE NAME
          // ======================================================
          Text(
            w.lineName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.black87,
              letterSpacing: -0.4,
            ),
          ),

          const SizedBox(height: 14),

          // ======================================================
          // STATS GRID
          // ======================================================
          Row(
            children: [
              _statCard(
                context,
                "Pass Rate",
                "${w.passRate.toStringAsFixed(1)}%",
                _passRateColor(w.passRate, scheme, good, danger),
              ),
              const SizedBox(width: 12),
              _statCard(context, "Failed", "${w.failed}", danger),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statCard(
                context,
                "High Risk",
                "${w.highRisk}",
                w.highRisk > 0 ? warning : scheme.primary,
              ),
              const SizedBox(width: 12),
              _statCard(context, "Total", "${w.total}", scheme.primary),
            ],
          ),

          const SizedBox(height: 16),

          // ======================================================
          // NARRATIVE
          // ======================================================
          Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: scheme.primary.withOpacity(0.06),
              border: Border.all(color: scheme.primary.withOpacity(0.14)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.psychology_alt_rounded,
                  color: scheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    narrative,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.45,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ======================================================
          // FAILURE REASONS
          // ======================================================
          _sectionTitle(context, "Top Failure Reasons"),
          const SizedBox(height: 10),

          if (w.topReasons.isEmpty)
            Text(
              "No failure reasons recorded.",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withOpacity(0.65),
                fontWeight: FontWeight.w600,
              ),
            )
          else
            ...w.topReasons.map((r) => _reasonRow(context, r, warning)),

          const SizedBox(height: 18),

          // ======================================================
          // RECOMMENDED ACTIONS
          // ======================================================
          _sectionTitle(context, "Recommended Actions"),
          const SizedBox(height: 10),
          ...actions.asMap().entries.map(
            (e) => _actionRow(context, e.key + 1, e.value, scheme.primary),
          ),

          const SizedBox(height: 18),

          // ======================================================
          // COMPARISON WITH BEST LINE
          // ======================================================
          if (bestLine != null) ...[
            Divider(color: Colors.black.withOpacity(0.06)),
            const SizedBox(height: 12),
            _sectionTitle(context, "Compared to Best Line"),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _compareTile(
                    context,
                    title: "Best",
                    lineName: bestLine!.lineName,
                    value: "${bestLine!.passRate.toStringAsFixed(1)}%",
                    tint: good,
                    icon: Icons.trending_up_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _compareTile(
                    context,
                    title: "Worst",
                    lineName: w.lineName,
                    value: "${w.passRate.toStringAsFixed(1)}%",
                    tint: danger,
                    icon: Icons.trending_down_rounded,
                  ),
                ),
              ],
            ),
            if (gap != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: danger.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: danger.withOpacity(0.14)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.compare_arrows_rounded, color: danger, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Performance gap: ${gap.toStringAsFixed(1)}%",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  // ======================================================
  // REUSABLE WIDGETS (UI-only)
  // ======================================================

  Widget _sectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w900,
        color: Colors.black87,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _badge(String text, Color tint) {
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
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 0.2,
          color: tint,
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
    final t = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color.withOpacity(0.07),
          border: Border.all(color: color.withOpacity(0.16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: t.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.3,
                color: Colors.black87,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: t.textTheme.bodySmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reasonRow(BuildContext context, Map reason, Color tint) {
    final scheme = Theme.of(context).colorScheme;
    final r = (reason["reason"] ?? "").toString();
    final c = (reason["count"] ?? "").toString();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.80),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.error_outline_rounded, color: tint, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              r,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: scheme.surface.withOpacity(0.85),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.black.withOpacity(0.06)),
            ),
            child: Text(
              c,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionRow(BuildContext context, int index, String text, Color tint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: tint.withOpacity(0.06),
        border: Border.all(color: tint.withOpacity(0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$index",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: tint,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _compareTile(
    BuildContext context, {
    required String title,
    required String lineName,
    required String value,
    required Color tint,
    required IconData icon,
  }) {
    final t = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: tint.withOpacity(0.07),
        border: Border.all(color: tint.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: tint),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 0.2,
                  color: tint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: t.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.black87,
              height: 1.0,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            lineName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Color _passRateColor(
    double passRate,
    ColorScheme scheme,
    Color good,
    Color danger,
  ) {
    if (passRate >= 90) return good;
    if (passRate >= 70) return scheme.primary;
    return danger;
  }

  // ======================================================
  // LOGIC (UNCHANGED)
  // ======================================================
  String _buildNarrative(
    ReportsWorstLineInsightEntity w,
    ReportsLineComparisonEntity? best,
  ) {
    final reasons = w.topReasons;
    final reasonsText = reasons.isEmpty
        ? "No recorded failure patterns."
        : "Top issues: ${reasons.map((e) => e["reason"]).take(2).join(", ")}.";

    if (best == null) {
      return "This line shows significantly lower performance. $reasonsText Immediate corrective action is recommended.";
    }

    final gap = (best.passRate - w.passRate).toStringAsFixed(1);
    return "This line underperforms compared to the best line by $gap%. $reasonsText This indicates recurring systematic issues that require corrective action.";
  }

  List<String> _recommendedActions(ReportsWorstLineInsightEntity w) {
    final actions = <String>[
      "Investigate the top failure reason and implement corrective steps.",
      "Review temperature and moisture logs for abnormal patterns.",
      "Perform a maintenance audit for this production line.",
    ];

    if (w.highRisk > 0) {
      actions.add(
        "High-risk alerts detected: recalibrate sensors immediately.",
      );
    }

    if (w.failed >= 3) {
      actions.add("Create a CAPA plan with supervisors and track improvement.");
    }

    return actions;
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
