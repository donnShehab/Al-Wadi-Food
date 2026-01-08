import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_summary_entity.dart';

class ReportsSummaryCards extends StatelessWidget {
  final ReportsSummaryEntity summary;

  const ReportsSummaryCards({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final total = summary.totalInspections;
    final passRate = summary.passRate;
    final failed = summary.failedCount;
    final highRisk = summary.highRiskCount;

    final status = _qcStatus(passRate, failed, highRisk);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ KPI GRID (4 cards)
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.55,
          children: [
            _kpiCard(
              context,
              title: "Total Inspections",
              value: total.toString(),
              icon: Icons.fact_check_rounded,
              color: scheme.primary,
            ),
            _kpiCard(
              context,
              title: "Pass Rate",
              value: "${passRate.toStringAsFixed(1)}%",
              icon: Icons.percent_rounded,
              color: Colors.green,
            ),
            _kpiCard(
              context,
              title: "Failed",
              value: failed.toString(),
              icon: Icons.close_rounded,
              color: Colors.redAccent,
            ),
            _kpiCard(
              context,
              title: "High Risk",
              value: highRisk.toString(),
              icon: Icons.warning_amber_rounded,
              color: Colors.orange,
            ),
          ],
        ),

        const SizedBox(height: 14),

        // ✅ Narrative Card (Executive Insight)
        _qcHealthNarrativeCard(
          context,
          status: status,
          passRate: passRate,
          failed: failed,
          highRisk: highRisk,
          total: total,
        ),
      ],
    );
  }

  // ============================================================
  // ✅ KPI Card
  // ============================================================
  Widget _kpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: scheme.surface,
        border: Border.all(color: color.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
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
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ Narrative Card
  // ============================================================
  Widget _qcHealthNarrativeCard(
    BuildContext context, {
    required _QCStatus status,
    required double passRate,
    required int failed,
    required int highRisk,
    required int total,
  }) {
    final scheme = Theme.of(context).colorScheme;

    final recommendation = _recommendation(passRate, failed, highRisk);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.surface,
        border: Border.all(color: status.color.withOpacity(0.18)),
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
          // ✅ Header Row
          Row(
            children: [
              Icon(Icons.insights_rounded, color: status.color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "QC Health Insight",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _statusBadge(status.label, status.color),
            ],
          ),

          const SizedBox(height: 12),

          // ✅ Narrative text
          Text(
            status.narrative,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),
          Divider(color: scheme.outline.withOpacity(0.12)),
          const SizedBox(height: 14),

          // ✅ Recommendation
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_rounded, color: scheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  recommendation,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String text, Color color) {
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

  _QCStatus _qcStatus(double passRate, int failed, int risk) {
    if (passRate < 75 || failed >= 3) {
      return _QCStatus(
        label: "CRITICAL",
        color: Colors.redAccent,
        narrative:
            "QC performance is below acceptable thresholds. Failure rate is high and requires immediate corrective action.",
      );
    }

    if (passRate < 90 || risk > 0) {
      return _QCStatus(
        label: "ATTENTION",
        color: Colors.orange,
        narrative:
            "QC performance is stable but risks and failure indicators suggest process instability. Action is recommended.",
      );
    }

    return _QCStatus(
      label: "HEALTHY",
      color: Colors.green,
      narrative:
          "QC performance is strong and stable. The factory is meeting quality expectations with minimal failures.",
    );
  }

  String _recommendation(double passRate, int failed, int risk) {
    if (passRate < 75) {
      return "Recommendation: Focus immediately on the worst-performing production line and fix the top 1–2 failure reasons. Assign CAPA tasks today.";
    }
    if (passRate < 90 || risk > 0) {
      return "Recommendation: Investigate high-risk alerts and implement preventive maintenance. Tighten QC checkpoints for critical reasons.";
    }
    return "Recommendation: Maintain current process stability. Consider optimizing throughput and continue monitoring early warning alerts.";
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
