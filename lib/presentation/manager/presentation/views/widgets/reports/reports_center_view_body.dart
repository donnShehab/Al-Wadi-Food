import 'package:alwadi_food/presentation/animations/fade_slide.dart';
import 'package:alwadi_food/presentation/animations/header_fade_slide.dart';
import 'package:alwadi_food/presentation/animations/screen_entry_animation.dart';
import 'package:alwadi_food/presentation/animations/staggered_fade_slide_item.dart';
import 'package:alwadi_food/presentation/manager/cubit/reports/reports_center_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/reports/reports_center_state.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/reports/reports_export_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Widgets
import 'reports_filter_selector.dart';
import 'reports_summary_cards.dart';
import 'reports_lines_comparison_section.dart';
import 'reports_top_failures_chart.dart';
import 'reports_worst_line_insight_section.dart';
import 'reports_lines_passrate_chart.dart';

class ReportsCenterViewBody extends StatefulWidget {
  const ReportsCenterViewBody({super.key});

  @override
  State<ReportsCenterViewBody> createState() => _ReportsCenterViewBodyState();
}

class _ReportsCenterViewBodyState extends State<ReportsCenterViewBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tabController;
  late final Animation<double> _tabAnimation;

  @override
  void initState() {
    super.initState();

    _tabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _tabAnimation = CurvedAnimation(
      parent: _tabController,
      curve: Curves.easeOutCubic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          return ScreenEntryAnimation(
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  HeaderFadeSlide(child: _header(context, state)),
                  Expanded(
                    child: TabBarView(
                      children: [
                        FadeSlide(
                          animation: _tabAnimation,
                          child: _summaryTab(context, state),
                        ),
                        FadeSlide(
                          animation: _tabAnimation,
                          child: _chartsTab(context, state),
                        ),
                        FadeSlide(
                          animation: _tabAnimation,
                          child: _insightsTab(context, state),
                        ),
                        FadeSlide(
                          animation: _tabAnimation,
                          child: _exportsTab(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _header(BuildContext context, ReportsCenterLoaded state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Reports Center",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            "QC analytics, dashboards and exports for management.",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 14),
          ReportsFilterSelector(
            selected: state.range,
            onChanged: (r) => context.read<ReportsCenterCubit>().changeRange(r),
          ),
          const SizedBox(height: 12),
          _miniKpiRow(context, state),
          const SizedBox(height: 14),
          _tabBar(context),
        ],
      ),
    );
  }

  Widget _tabBar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: scheme.surfaceVariant.withOpacity(0.22),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: scheme.outline.withOpacity(0.10)),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurface.withOpacity(0.65),
        labelStyle: const TextStyle(fontWeight: FontWeight.w900),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.92),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        tabs: const [
          Tab(text: "Summary"),
          Tab(text: "Charts"),
          Tab(text: "Insights"),
          Tab(text: "Exports"),
        ],
        onTap: (_) => _tabController.forward(from: 0),
      ),
    );
  }

  Widget _miniKpiRow(BuildContext context, ReportsCenterLoaded state) {
    final s = state.summary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.85),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          _miniKpi(
            context,
            label: "Total",
            value: s.totalInspections.toString(),
            color: Theme.of(context).colorScheme.primary,
          ),
          _divider(),
          _miniKpi(
            context,
            label: "Pass",
            value: "${s.passRate.toStringAsFixed(1)}%",
            color: const Color(0xFF2ECC71),
          ),
          _divider(),
          _miniKpi(
            context,
            label: "Failed",
            value: "${s.failedCount}",
            color: const Color(0xFFDC143C),
          ),
          _divider(),
          _miniKpi(
            context,
            label: "Risk",
            value: "${s.highRiskCount}",
            color: const Color(0xFFF4B400),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 26,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    color: Colors.black.withOpacity(0.07),
  );

  Widget _miniKpi(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    final t = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: t.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: -0.2,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: t.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TABS
  // ---------------------------------------------------------------------------

  // ✅ SUMMARY (Premium refined)
  Widget _summaryTab(BuildContext context, ReportsCenterLoaded state) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      children: [
        ReportsSection(
          title: "Summary Overview",
          subtitle: "Quick executive snapshot of QC performance.",
          child: ReportsSummaryCards(summary: state.summary),
        ),
        const SizedBox(height: 24),
        ReportsSection(
          title: "Line Performance",
          subtitle: "Compare production lines by pass rate and risk.",
          child: ReportsLinesComparisonSection(
            lines: state.linesComparison,
            bestLine: state.bestLine,
            worstLine: state.worstLine,
          ),
        ),
      ],
    );
  }

  Widget _chartsTab(BuildContext context, ReportsCenterLoaded state) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      children: [
        ReportsTopFailuresChart(reasons: state.topFailureReasons),
        const SizedBox(height: 20),
        ReportsLinesPassRateChart(lines: state.linesComparison),
      ],
    );
  }

  Widget _insightsTab(BuildContext context, ReportsCenterLoaded state) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      children: [
        ReportsWorstLineInsightSection(
          worstInsight: state.worstLineInsight,
          bestLine: state.bestLine,
        ),
      ],
    );
  }

  Widget _exportsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      children: [
        ReportsExportTab(
          onExportPdf: () => context.read<ReportsCenterCubit>().exportPdf(),
          onExportExcel: () => context.read<ReportsCenterCubit>().exportExcel(),
        ),
      ],
    );
  }
}

class ReportsSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const ReportsSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: t.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: t.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black54,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }
}
