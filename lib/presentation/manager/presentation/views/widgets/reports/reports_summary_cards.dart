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
        // ======================================================
        // SUMMARY KPI GRID (STAGGERED ENTRY)
        // ======================================================
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.45,
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

        // ======================================================
        // QC INSIGHT (SOFT ENTRY)
        // ======================================================
        StaggeredSlideFade(
          index: 4,
          delay: const Duration(milliseconds: 320),
          child: _qcInsightCard(context, summary),
        ),
      ],
    );
  }

  // ======================================================
  // PRESSABLE KPI CARD (EXECUTIVE FEEDBACK)
  // ======================================================
  Widget _pressableKpi(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return PressableScale(
      onTap: () {}, // purely tactile, no action
      child: _kpiCard(
        context,
        title: title,
        value: value,
        icon: icon,
        color: color,
      ),
    );
  }

  // ======================================================
  // KPI CARD (VISUALS UNCHANGED)
  // ======================================================
  Widget _kpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.18), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
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

  // ======================================================
  // QC INSIGHT CARD (UNCHANGED LOGIC)
  // ======================================================
  Widget _qcInsightCard(BuildContext context, ReportsSummaryEntity s) {
    final status = _qcStatus(s.passRate, s.failedCount, s.highRiskCount);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFF0A1931),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.withOpacity(0.15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.50),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: Colors.amber,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "QC Health Insight",
                  style: TextStyle(
                    color: Colors.amber.shade300,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
              _statusBadge(status.label, status.color),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            status.narrative,
            style: const TextStyle(
              color: Colors.white,
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }

  // ======================================================
  // STATUS LOGIC (UNCHANGED)
  // ======================================================
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
