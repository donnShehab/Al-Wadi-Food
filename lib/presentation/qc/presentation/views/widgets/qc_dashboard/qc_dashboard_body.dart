import 'package:alwadi_food/presentation/qc/domain/entites/qc_alert_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_recommendation_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_trend_day_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_action_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_alerts_list.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_header_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_hint_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_kpi_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_recent_activity_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_risk_alert_card.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class QCDashboardBody extends StatelessWidget {
  final int pendingCount;
  final int passedToday;
  final int failedToday;
  final List<QCResultEntity> recentResults;

  // موجودين من cubit بس مش رح نعرضهم هنا
  final String riskLevel;
  final List<QCAlertEntity> alerts;
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
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ✅ HEADER
          const QCHeaderSection(),
          const SizedBox(height: 20),

          /// ✅ KPIs (TODAY)
          QCKPISection(
            pendingCount: pendingCount,
            passedToday: passedToday,
            failedToday: failedToday,
          ),
          const SizedBox(height: 18),

          const SizedBox(height: 22),

          /// ✅ ACTION SECTION (الزر الأساسي)
          QCActionSection(pendingCount: pendingCount),
          const SizedBox(height: 18),

          /// ✅ HINT (تنبيه يومي)
          const QCHintSection(),
          const SizedBox(height: 26),

          /// ✅ RECENT ACTIVITY (آخر 3 فقط)
          QCRecentActivitySection(
            recentResults: recentResults.take(3).toList(),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
