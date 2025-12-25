import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_action_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_chart_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_header_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_hint_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_kpi_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_pass_rate_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_recent_activity_section.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class QCDashboardBody extends StatelessWidget {
  final int pendingCount;
  final int passedToday;
  final int failedToday;
  final List<QCResultEntity> recentResults;

  const QCDashboardBody({
    super.key,
    required this.pendingCount,
    required this.passedToday,
    required this.failedToday,
    required this.recentResults,
  });

  @override
  Widget build(BuildContext context) {
    final totalToday = passedToday + failedToday;
    final passRate = totalToday == 0
        ? 0
        : ((passedToday / totalToday) * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const QCHeaderSection(),
            const SizedBox(height: 20),

            QCKPISection(
              pendingCount: pendingCount,
              passedToday: passedToday,
              failedToday: failedToday,
            ),
            const SizedBox(height: 22),

            QCPassRateCard(passRate: passRate),
            const SizedBox(height: 22),

            QCChartSection(passedToday: passedToday, failedToday: failedToday),
            const SizedBox(height: 26),

            QCActionSection(pendingCount: pendingCount),
            const SizedBox(height: 18),

            const QCHintSection(),
            const SizedBox(height: 26),

            QCRecentActivitySection(recentResults: recentResults),
          ],
        ),
      ),
    );
  }
}
