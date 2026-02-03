import 'package:alwadi_food/presentation/qc/cubit/qc_reports/qc_reports_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_reports/qc_reports_state.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_reports/qc_generate_report_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_reports/qc_reports_header.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_reports/qc_recent_reports_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QCReportsViewBodyBlocConsumer extends StatelessWidget {
  const QCReportsViewBodyBlocConsumer({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final bg = BoxDecoration(
      gradient: RadialGradient(
        center: Alignment.topCenter,
        radius: 1.15,
        colors: [
          theme.colorScheme.surface,
          theme.colorScheme.primary.withOpacity(0.035),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      body: DecoratedBox(
        decoration: bg,
        child: SafeArea(
          child: BlocConsumer<QCReportsCubit, QCReportsState>(
            listener: (context, state) {
              if (state is QCReportsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
              }

              if (state is QCReportGenerated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is QCReportsLoading;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 96),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const QCReportsHeader(),
                    const SizedBox(height: 18),

                    _SectionTitle(title: "Generate Reports"),
                    const SizedBox(height: 12),

                    /// ✅ Weekly
                    QCReportGenerateCard(
                      title: "Generate Weekly Report",
                      subtitle:
                          "Professional weekly report: KPI, daily breakdown, trend, failures and recommendations.",
                      icon: Icons.picture_as_pdf_rounded,
                      buttonText: "Generate",
                      isLoading: isLoading,
                      onPressed: () =>
                          context.read<QCReportsCubit>().generateWeeklyReport(),
                    ),

                    const SizedBox(height: 14),

                    /// ✅ Monthly
                    QCReportGenerateCard(
                      title: "Generate Monthly Report",
                      subtitle:
                          "Monthly report with full KPI summary + last 7 days trend + failures analysis.",
                      icon: Icons.calendar_month_rounded,
                      buttonText: "Generate",
                      isLoading: isLoading,
                      onPressed: () => context
                          .read<QCReportsCubit>()
                          .generateMonthlyReport(),
                    ),

                    const SizedBox(height: 22),

                    _SectionTitle(title: "Recent Reports"),
                    const SizedBox(height: 12),

                    if (state is QCReportsLoaded)
                      QCRecentReportsList(reports: state.reports),

                    if (state is QCReportsLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Center(child: CircularProgressIndicator()),
                      ),

                    if (state is QCReportsInitial) _EmptyState(theme: theme),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "No reports generated yet.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
