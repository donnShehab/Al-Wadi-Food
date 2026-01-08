import 'package:alwadi_food/presentation/manager/cubit/reports/reports_center_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/reports/reports_center_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'reports_filter_selector.dart';
import 'reports_summary_cards.dart';
import 'reports_lines_comparison_section.dart';
import 'reports_top_failures_chart.dart';
import 'reports_worst_line_insight_section.dart';
import 'reports_lines_passrate_chart.dart';

class ReportsCenterViewBody extends StatelessWidget {
  const ReportsCenterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCenterCubit, ReportsCenterState>(
      builder: (context, state) {
        if (state is ReportsCenterLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ReportsCenterError) {
          return Center(child: Text(state.message));
        }

        if (state is ReportsCenterLoaded) {
          return DefaultTabController(
            length: 4,
            child: Column(
              children: [
                _premiumHeader(context, state),
                Expanded(
                  child: TabBarView(
                    children: [
                      _summaryTab(context, state),
                      _chartsTab(context, state),
                      _insightsTab(context, state),
                      _exportsTab(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  // ============================================================
  // ✅ PREMIUM HEADER (Enterprise)
  // ============================================================
  Widget _premiumHeader(BuildContext context, ReportsCenterLoaded state) {
    final scheme = Theme.of(context).colorScheme;
    final s = state.summary;

    // ✅ status logic
    final status = _qcStatus(s.passRate, s.failedCount, s.highRiskCount);

    // ✅ fake updated time (بدنا نخليها real من cubit)
    final now = DateTime.now();
    final updatedText = "${now.hour}:${now.minute.toString().padLeft(2, "0")}";

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          bottom: BorderSide(color: scheme.outline.withOpacity(0.10)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ TOP BAR
          Row(
            children: [
              Expanded(
                child: Text(
                  "Reports Center",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _actionsMenu(context),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            "QC analytics, dashboards and exports for management.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.65),
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 12),

          // ✅ STATUS + RANGE + UPDATED
          Row(
            children: [
              _badge(
                label: status.label,
                color: status.color,
                icon: Icons.circle,
                filled: true,
              ),
              const SizedBox(width: 10),
              _badge(
                label: " ${state.range.name.toUpperCase()} ",
                color: scheme.primary,
                icon: Icons.calendar_month_rounded,
              ),
              const Spacer(),
              Text(
                "Updated: $updatedText",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface.withOpacity(0.55),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ✅ FILTER SELECTOR
          ReportsFilterSelector(
            selected: state.range,
            onChanged: (r) => context.read<ReportsCenterCubit>().changeRange(r),
          ),

          const SizedBox(height: 14),

          // ✅ MINI KPI ROW
          _miniKpiRow(context, state),

          const SizedBox(height: 14),

          // ✅ TAB BAR
          _premiumTabBar(context),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ TabBar Container
  // ============================================================
  Widget _premiumTabBar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withOpacity(0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline.withOpacity(0.10)),
      ),
      child: TabBar(
        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: scheme.primary,
        ),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: scheme.onSurface.withOpacity(0.65),
        labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        tabs: const [
          Tab(text: "Summary"),
          Tab(text: "Charts"),
          Tab(text: "Insights"),
          Tab(text: "Exports"),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ Action Menu (optional shortcuts)
  // ============================================================
  Widget _actionsMenu(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      tooltip: "Actions",
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: scheme.primary.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.primary.withOpacity(0.18)),
        ),
        child: Icon(Icons.more_vert_rounded, color: scheme.primary),
      ),
      onSelected: (value) async {
        final cubit = context.read<ReportsCenterCubit>();

        if (value == "pdf") {
          _snack(context, "⏳ Generating PDF...");
          final ok = await cubit.exportPdf();
          _snack(context, ok ? "✅ PDF Exported" : "❌ PDF Failed", success: ok);
        }

        if (value == "excel") {
          _snack(context, "⏳ Generating Excel...");
          final ok = await cubit.exportExcel();
          _snack(
            context,
            ok ? "✅ Excel Exported" : "❌ Excel Failed",
            success: ok,
          );
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: "pdf",
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent),
              SizedBox(width: 10),
              Text("Export PDF"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: "excel",
          child: Row(
            children: [
              Icon(Icons.table_chart_rounded, color: Colors.green),
              SizedBox(width: 10),
              Text("Export Excel"),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ✅ MINI KPI ROW
  // ============================================================
  Widget _miniKpiRow(BuildContext context, ReportsCenterLoaded state) {
    final scheme = Theme.of(context).colorScheme;
    final s = state.summary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: scheme.surface,
        border: Border.all(color: scheme.outline.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _miniKpi(context, "Total", "${s.totalInspections}", scheme.primary),
          _divider(scheme),
          _miniKpi(
            context,
            "Pass",
            "${s.passRate.toStringAsFixed(1)}%",
            Colors.green,
          ),
          _divider(scheme),
          _miniKpi(context, "Failed", "${s.failedCount}", Colors.redAccent),
          _divider(scheme),
          _miniKpi(context, "Risk", "${s.highRiskCount}", Colors.orange),
        ],
      ),
    );
  }

  Widget _divider(ColorScheme scheme) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: scheme.outline.withOpacity(0.12),
    );
  }

  Widget _miniKpi(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final scheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface.withOpacity(0.60),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ TAB: SUMMARY
  // ============================================================
  Widget _summaryTab(BuildContext context, ReportsCenterLoaded state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section(
          context,
          title: "Summary Overview",
          subtitle: "Quick executive snapshot of QC performance.",
          child: ReportsSummaryCards(summary: state.summary),
        ),
        const SizedBox(height: 20),
        _section(
          context,
          title: "Line Performance",
          subtitle: "Compare production lines by pass rate and risk.",
          child: ReportsLinesComparisonSection(
            lines: state.linesComparison,
            bestLine: state.bestLine,
            worstLine: state.worstLine,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ============================================================
  // ✅ TAB: CHARTS
  // ============================================================
  Widget _chartsTab(BuildContext context, ReportsCenterLoaded state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section(
          context,
          title: "Top Failure Reasons",
          subtitle: "Most common reasons causing QC failures in this range.",
          child: ReportsTopFailuresChart(reasons: state.topFailureReasons),
        ),
        const SizedBox(height: 20),
        _section(
          context,
          title: "Line Pass Rate Dashboard",
          subtitle: "Corporate overview for top performing production lines.",
          child: ReportsLinesPassRateChart(lines: state.linesComparison),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ============================================================
  // ✅ TAB: INSIGHTS
  // ============================================================
  Widget _insightsTab(BuildContext context, ReportsCenterLoaded state) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section(
          context,
          title: "Operational Insight",
          subtitle: "System-generated insights for corrective actions.",
          child: ReportsWorstLineInsightSection(
            worstInsight: state.worstLineInsight,
            bestLine: state.bestLine,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ============================================================
  // ✅ TAB: EXPORTS
  // ============================================================
  Widget _exportsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section(
          context,
          title: "Export Reports",
          subtitle: "Generate professional PDF/Excel files for management.",
          child: Column(
            children: [
              _exportCard(
                context,
                title: "Export PDF Report",
                subtitle:
                    "Summary + charts + worst line insight in one report.",
                icon: Icons.picture_as_pdf_rounded,
                color: Colors.redAccent,
                onTap: () => context.read<ReportsCenterCubit>().exportPdf(),
              ),
              const SizedBox(height: 14),
              _exportCard(
                context,
                title: "Export Excel Sheet",
                subtitle: "Detailed inspections table for analysis & tracking.",
                icon: Icons.table_chart_rounded,
                color: Colors.green,
                onTap: () => context.read<ReportsCenterCubit>().exportExcel(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ✅ SECTION WRAPPER (Unified)
  // ============================================================
  Widget _section(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: scheme.onSurface.withOpacity(0.65),
          ),
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }

  // ============================================================
  // ✅ EXPORT CARD
  // ============================================================
  Widget _exportCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: scheme.surface,
          border: Border.all(color: color.withOpacity(0.20)),
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
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.65),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ✅ BADGE
  // ============================================================
  Widget _badge({
    required String label,
    required Color color,
    required IconData icon,
    bool filled = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: filled ? color.withOpacity(0.12) : Colors.transparent,
        border: Border.all(color: color.withOpacity(0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 11,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ QC STATUS
  // ============================================================
  _QCStatus _qcStatus(double passRate, int failed, int risk) {
    if (passRate < 75 || failed >= 3) {
      return _QCStatus("Critical", Colors.redAccent);
    }
    if (passRate < 90 || risk > 0) {
      return _QCStatus("Attention", Colors.orange);
    }
    return _QCStatus("Healthy", Colors.green);
  }

  void _snack(BuildContext context, String msg, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _QCStatus {
  final String label;
  final Color color;
  _QCStatus(this.label, this.color);
}
