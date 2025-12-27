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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(title: const Text("QC Reports"), centerTitle: true),
      body: SafeArea(
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
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const QCReportsHeader(),
                  const SizedBox(height: 18),

                  /// ✅ Weekly
                  QCReportGenerateCard(
                    title: "Generate Weekly Report",
                    subtitle:
                        "Professional QC weekly report: KPI, daily breakdown, trend, failures and recommendations.",
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
                    onPressed: () =>
                        context.read<QCReportsCubit>().generateMonthlyReport(),
                  ),

                  const SizedBox(height: 26),

                  Text(
                    "Recent Reports",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (state is QCReportsLoaded)
                    QCRecentReportsList(reports: state.reports),

                  if (state is QCReportsLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),

                  if (state is QCReportsInitial)
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: Center(child: Text("No reports generated yet.")),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
