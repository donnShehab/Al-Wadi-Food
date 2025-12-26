import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_reports/qc_report_action_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_reports/qc_report_history_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_reports/qc_reports_header.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';

class QCReportsViewBody extends StatelessWidget {
  const QCReportsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const QCReportsHeader(),
          const SizedBox(height: 20),

          const QCReportActionCard(),
          const SizedBox(height: 18),

          const QCReportHistoryCard(),
        ],
      ),
    );
  }
}
