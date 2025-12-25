import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_recommendation_dashboard/qc_recommendation_card.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_recommendation_entity.dart';
class QCRecommendationSection extends StatelessWidget {
  final List<QCRecommendation> recommendations;

  const QCRecommendationSection({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (recommendations.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Auto Recommendations",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        ...recommendations.map((rec) => RecommendationCard(rec: rec)),
      ],
    );
  }
}
