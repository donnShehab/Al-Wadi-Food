import 'package:alwadi_food/presentation/animations/pressable_card.dart';
import 'package:alwadi_food/presentation/animations/staggered_fade_slide_item.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_summary_entity.dart';

class ReportsSummaryCards extends StatelessWidget {
  final ReportsSummaryEntity summary;

  const ReportsSummaryCards({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final s = summary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.55,
          children: [
            StaggeredSlideFade(
              index: 0,
              child: _pressableKpi(
                context,
                title: "Total Inspections",
                value: s.totalInspections.toString(),
                color: const Color(0xFF0A1931),
                icon: Icons.fact_check_rounded,
              ),
            ),
            StaggeredSlideFade(
              index: 1,
              delay: const Duration(milliseconds: 80),
              child: _pressableKpi(
                context,
                title: "Pass Rate",
                value: "${s.passRate.toStringAsFixed(1)}%",
                color: const Color(0xFF2E8B57),
                icon: Icons.percent_rounded,
              ),
            ),
            StaggeredSlideFade(
              index: 2,
              delay: const Duration(milliseconds: 160),
              child: _pressableKpi(
                context,
                title: "Failed",
                value: s.failedCount.toString(),
                color: const Color(0xFFA30015),
                icon: Icons.close_rounded,
              ),
            ),
            StaggeredSlideFade(
              index: 3,
              delay: const Duration(milliseconds: 240),
              child: _pressableKpi(
                context,
                title: "High Risk",
                value: s.highRiskCount.toString(),
                color: const Color(0xFFFF8F00),
                icon: Icons.warning_amber_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StaggeredSlideFade(
          index: 4,
          delay: const Duration(milliseconds: 320),
          child: _qcInsightCard(context, summary),
        ),
      ],
    );
  }

  Widget _pressableKpi(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return PressableScale(
      onTap: () {}, // UI-only tactile
      child: _kpiCard(
        context,
        title: title,
        value: value,
        icon: icon,
        color: color,
      ),
    );
  }

  Widget _kpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final t = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.14)),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: t.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                      color: Colors.black87,
                      height: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qcInsightCard(BuildContext context, ReportsSummaryEntity s) {
    final status = _qcStatus(s.passRate, s.failedCount, s.highRiskCount);
    final t = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF0A1931), Color(0xFF111827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.10)),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: Colors.amber,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "QC Health Insight",
                  style: t.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              _statusBadge(status.label, status.color),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            status.narrative,
            style: t.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.90),
              fontWeight: FontWeight.w700,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 0.2,
          color: Colors.white.withOpacity(0.95),
        ),
      ),
    );
  }

  // LOGIC unchanged
  _QCStatus _qcStatus(double passRate, int failed, int risk) {
    if (passRate < 75 || failed >= 3) {
      return _QCStatus(
        label: "CRITICAL",
        color: const Color(0xFFA30015),
        narrative:
            "QC performance is below acceptable thresholds. Immediate corrective action is required.",
      );
    }

    if (passRate < 90 || risk > 0) {
      return _QCStatus(
        label: "ATTENTION",
        color: const Color(0xFFFF8F00),
        narrative:
            "QC performance is stable but shows signs of risk. Action is recommended.",
      );
    }

    return _QCStatus(
      label: "HEALTHY",
      color: const Color(0xFF2E8B57),
      narrative:
          "QC performance is strong and stable. Quality expectations are being met.",
    );
  }
}

class _QCStatus {
  final String label;
  final Color color;
  final String narrative;

  _QCStatus({
    required this.label,
    required this.color,
    required this.narrative,
  });
}
