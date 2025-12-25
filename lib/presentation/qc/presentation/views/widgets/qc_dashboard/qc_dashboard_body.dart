import 'package:alwadi_food/presentation/qc/domain/entites/qc_recommendation_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_trend_day_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_action_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_alerts_list.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_chart_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_header_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_hint_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_kpi_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_pass_rate_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_recent_activity_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_risk_alert_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_recommendation_dashboard/qc_recommendation_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_trend_dashboard/qc_trend_section.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class QCDashboardBody extends StatelessWidget {
  final int pendingCount;
  final int passedToday;
  final int failedToday;
  final List<QCResultEntity> recentResults;
  final String riskLevel;
  final List<String> alerts;
  final List<QCTrendDayEntity> trend;
  final List<QCRecommendation> recommendations;

  const QCDashboardBody({
    super.key,
    required this.pendingCount,
    required this.passedToday,
    required this.failedToday,
    required this.recentResults,
    required this.riskLevel,
    required this.alerts,
    required this.trend,
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    final totalToday = passedToday + failedToday;
    final passRate = totalToday == 0
        ? 0
        : ((passedToday / totalToday) * 100).round();

    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ✅ HEADER
          const QCHeaderSection(),
          const SizedBox(height: 20),

          /// ✅ KPIs
          QCKPISection(
            pendingCount: pendingCount,
            passedToday: passedToday,
            failedToday: failedToday,
          ),
          const SizedBox(height: 18),
          QCTrendSection(trend: trend),
          const SizedBox(height: 22),

          /// ✅ RISK CARD
          QCRiskAlertCard(riskLevel: riskLevel),
          const SizedBox(height: 18),

          /// ✅ ALERTS
          QCAlertsList(alerts: alerts),
          const SizedBox(height: 24),

          /// ✅ Recommendation
          QCRecommendationSection(recommendations: recommendations),
          const SizedBox(height: 26),

          /// ✅ PASS RATE
          QCPassRateCard(passRate: passRate),
          const SizedBox(height: 22),

          /// ✅ CHART
          QCChartSection(passedToday: passedToday, failedToday: failedToday),
          const SizedBox(height: 26),

          /// ✅ ACTION SECTION
          QCActionSection(pendingCount: pendingCount),
          const SizedBox(height: 18),

          /// ✅ HINT
          const QCHintSection(),
          const SizedBox(height: 26),

          /// ✅ RECENT ACTIVITY
          QCRecentActivitySection(recentResults: recentResults),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
