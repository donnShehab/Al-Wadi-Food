import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_recommendation_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_recommendation_dashboard/qc_recommendation_batch_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QCRecommendationBottomSheet extends StatelessWidget {
  final QCRecommendation rec;
  final List<ProductionBatchEntity> allBatches;

  const QCRecommendationBottomSheet({
    super.key,
    required this.rec,
    required this.allBatches,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// ✅ Find affected batches
    final affected = allBatches
        .where((b) => rec.affectedBatches.contains(b.batchId))
        .toList();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// ✅ Top indicator
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 16),

            /// ✅ Title Row
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: rec.severity == "high"
                      ? Colors.red
                      : rec.severity == "medium"
                      ? Colors.orange
                      : Colors.green,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    rec.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                rec.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ✅ Action Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      rec.action,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            /// ✅ Affected Batches title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Affected Batches (${affected.length})",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// ✅ Batch list
            if (affected.isEmpty)
              Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  "No matching batches found in production records.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: affected.map((batch) {
                    final label =
                        "${batch.product} •${batch.line} (Batch ${batch.batchId})";

                    return RecommendationBatchTile(
                      batchId: batch.batchId,
                      label: label,
                      operator: batch.operatorName,
                      line: batch.line,
                      product: batch.product,
                      onTap: () {
                        Navigator.pop(context);
                        context.push(
                          "${AppRouter.KbatchDetailsView}/${batch.batchId}",
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 14),

            /// ✅ Close Button
            Container(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
