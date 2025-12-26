import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_recommendation_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_recommendation_dashboard/qc_recommendation_confg.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_recommendation_dashboard/qc_recommendation_details_sheet.dart';
import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final QCRecommendation rec;
  final List<ProductionBatchEntity> allBatches;

  const RecommendationCard({
    super.key,
    required this.rec,
    required this.allBatches,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = RecommendationConfig.fromSeverity(rec.severity);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) {
            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.55,
              maxChildSize: 0.95,
              builder: (_, controller) {
                return QCRecommendationBottomSheet(
                  rec: rec,
                  allBatches: allBatches,
                );
              },
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: config.bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: config.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ Header
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: config.iconColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(config.icon, color: config.iconColor, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    rec.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _severityChip(theme, config.iconColor, rec.severity),
              ],
            ),

            const SizedBox(height: 12),

            /// ✅ Description
            Text(
              rec.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            /// ✅ Tap hint
            Row(
              children: [
                Icon(Icons.touch_app, size: 16, color: config.iconColor),
                const SizedBox(width: 8),
                Text(
                  "Tap to view affected batches",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _severityChip(ThemeData theme, Color color, String severity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        severity.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
