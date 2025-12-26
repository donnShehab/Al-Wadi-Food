import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_alert_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_alerts_list.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_risk_alert_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_insights/qc_insights_header.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_recommendation_dashboard/qc_recommendation_section.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_recommendation_entity.dart';
import 'package:alwadi_food/theme.dart';

class QCInsightsViewBody extends StatelessWidget {
  final String riskLevel;
  final List<QCAlertEntity> alerts;
  final List<QCRecommendation> recommendations;
  final List<ProductionBatchEntity> allBatches;

  const QCInsightsViewBody({
    super.key,
    required this.riskLevel,
    required this.alerts,
    required this.recommendations,
    required this.allBatches,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const QCInsightsHeader(),
          const SizedBox(height: 20),

          QCRiskAlertCard(riskLevel: riskLevel),
          const SizedBox(height: 16),

          QCAlertsList(alerts: alerts),
          const SizedBox(height: 20),

          QCRecommendationSection(
            recommendations: recommendations,
            allBatches: allBatches,
          ),
        ],
      ),
    );
  }
}
