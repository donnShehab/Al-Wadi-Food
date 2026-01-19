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

    // EMPTY STATE
    if (worstInsight == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: scheme.surface,
          border: Border.all(color: scheme.outline.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: scheme.onSurfaceVariant,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "No insight available for this range.",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
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
      padding: const EdgeInsets.all(26),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFA30015).withOpacity(0.85),
            const Color(0xFF8B0012).withOpacity(0.85),
            const Color(0xFF6E000E).withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFA30015).withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A1931).withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, 14),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.trending_down_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  "Worst Line Insight",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              _badge("CRITICAL", Colors.white),
            ],
          ),

          const SizedBox(height: 22),

          // ======================================================
          // LINE NAME
          // ======================================================
          Text(
            w.lineName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 22),

          // ======================================================
          // STATS GRID
          // ======================================================
          Row(
            children: [
              _statCard(
                context,
                "Pass Rate",
                "${w.passRate.toStringAsFixed(1)}%",
                const Color(0xFF2E8B57),
              ),
              const SizedBox(width: 14),
              _statCard(
                context,
                "Failed",
                "${w.failed}",
                const Color(0xFFFF6B6B),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _statCard(
                context,
                "High Risk",
                "${w.highRisk}",
                const Color(0xFFFFC107),
              ),
              const SizedBox(width: 14),
              _statCard(
                context,
                "Total",
                "${w.total}",
                const Color(0xFF4FC3F7),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ======================================================
          // NARRATIVE
          // ======================================================
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.black.withOpacity(0.20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.psychology_alt_rounded,
                  color: Colors.amber,
                  size: 28,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    narrative,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          // ======================================================
          // FAILURE REASONS
          // ======================================================
          _sectionTitle(context, "Top Failure Reasons"),
          const SizedBox(height: 14),

          if (w.topReasons.isEmpty)
            Text(
              "No failure reasons recorded.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w700,
              ),
            )
          else
            ...w.topReasons.map((r) => _reasonRow(context, r)),

          const SizedBox(height: 26),

          // ======================================================
          // RECOMMENDED ACTIONS
          // ======================================================
          _sectionTitle(context, "Recommended Actions"),
          const SizedBox(height: 14),
          ...actions.map((a) => _actionRow(context, a)),

          const SizedBox(height: 26),

          // ======================================================
          // COMPARISON WITH BEST LINE
          // ======================================================
          if (bestLine != null) ...[
            Divider(color: Colors.white.withOpacity(0.30)),
            const SizedBox(height: 14),
            _sectionTitle(context, "Compared to Best Line"),
            const SizedBox(height: 10),
            Text(
              "✔ Best Line: ${bestLine!.lineName} (${bestLine!.passRate.toStringAsFixed(1)}%)",
              style: const TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              "✘ Worst Line: ${w.lineName} (${w.passRate.toStringAsFixed(1)}%)",
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (gap != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Performance Gap: ${gap.toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ======================================================
  // REUSABLE WIDGETS
  // ======================================================
  Widget _sectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 12,
          letterSpacing: 0.4,
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withOpacity(0.14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reasonRow(BuildContext context, Map reason) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withOpacity(0.14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.amber,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              reason["reason"].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _badge(reason["count"].toString(), Colors.white),
        ],
      ),
    );
  }

  Widget _actionRow(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
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
