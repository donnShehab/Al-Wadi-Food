import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_recommendation_entity.dart';
import 'qc_recommendation_card.dart';

class QCRecommendationSection extends StatelessWidget {
  final List<QCRecommendation> recommendations;
  final List<ProductionBatchEntity> allBatches;

  const QCRecommendationSection({
    super.key,
    required this.recommendations,
    required this.allBatches,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (recommendations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "No recommendations for this week ✅",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final high = recommendations.where((e) => e.severity == "high").toList();
    final med = recommendations.where((e) => e.severity == "medium").toList();
    final low = recommendations.where((e) => e.severity == "low").toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Auto Recommendations",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Smart insights generated from QC patterns (Last 7 Days)",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),

        if (high.isNotEmpty) ...[
          _sectionTitle("High Priority", Colors.red, theme),
          ...high.map(
            (rec) => RecommendationCard(rec: rec, allBatches: allBatches),
          ),
          const SizedBox(height: 20),
        ],

        if (med.isNotEmpty) ...[
          _sectionTitle("Medium Priority", Colors.orange, theme),
          ...med.map(
            (rec) => RecommendationCard(rec: rec, allBatches: allBatches),
          ),
          const SizedBox(height: 20),
        ],

        if (low.isNotEmpty) ...[
          _sectionTitle("Low Priority", Colors.green, theme),
          ...low.map(
            (rec) => RecommendationCard(rec: rec, allBatches: allBatches),
          ),
        ],
      ],
    );
  }

  Widget _sectionTitle(String title, Color color, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(radius: 6, backgroundColor: color),
          const SizedBox(width: 10),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
