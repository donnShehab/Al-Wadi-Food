import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_analytics/qc_analytics_header.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_analytics/qc_analytics_insights_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_analytics/qc_analytics_kpi_row.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_analytics/qc_analytics_trend_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_analytics/qc_top_failure_reasons_card.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_trend_day_entity.dart';

class QCAnalyticsViewBody extends StatelessWidget {
  final List<QCTrendDayEntity> trend;
  final List<QCResultEntity> results;

  const QCAnalyticsViewBody({
    super.key,
    required this.trend,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const QCAnalyticsHeader(),
          const SizedBox(height: 20),

          QCAnalyticsKPIRow(trend: trend),
          const SizedBox(height: 22),

          QCAnalyticsTrendCard(trend: trend),
          const SizedBox(height: 22),
          QCTopFailureReasonsCard(results: results),
          const SizedBox(height: 22),

          QCAnalyticsInsightsCard(trend: trend),
        ],
      ),
    );
  }
}
