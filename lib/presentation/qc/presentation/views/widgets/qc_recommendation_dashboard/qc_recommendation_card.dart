import 'package:alwadi_food/presentation/qc/domain/entites/qc_recommendation_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_recommendation_dashboard/qc_recommendation_confg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecommendationCard extends StatelessWidget {
  final QCRecommendation rec;

  const RecommendationCard({required this.rec});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final config = RecommendationConfig.fromSeverity(rec.severity);

    return Container(
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Bubble
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

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        rec.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Severity chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: config.iconColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        rec.severity.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Description
                Text(
                  rec.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),

                // Action Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.80)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 18,
                        color: config.iconColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          rec.action,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ Helper config: icon + colors based on severity
