import 'package:alwadi_food/core/utils/date_formatter.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_risk_chip.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_status_chip.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class TraceResultCard extends StatelessWidget {
  final String batchId;
  final String product;
  final String line;
  final String status;

  final String? imageUrl;
  final int? quantity;
  final DateTime? createdAt;

  final int riskScore;
  final VoidCallback onTap;

  const TraceResultCard({
    super.key,
    required this.batchId,
    required this.product,
    required this.line,
    required this.status,
    required this.riskScore,
    required this.onTap,
    this.imageUrl,
    this.quantity,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget thumb() {
      if (imageUrl == null || imageUrl!.trim().isEmpty) {
        return Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: scheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: scheme.outline.withOpacity(0.2)),
          ),
          child: Icon(
            Icons.image_rounded,
            color: scheme.primary.withOpacity(0.7),
          ),
        );
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Image.network(
          imageUrl!,
          width: 54,
          height: 54,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withOpacity(0.6),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(
              Icons.broken_image_rounded,
              color: scheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
      );
    }

    Widget chip(String text, IconData icon) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withOpacity(0.35),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: scheme.outline.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: scheme.onSurface.withOpacity(0.7)),
            const SizedBox(width: 6),
            Text(
              text,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: scheme.onSurface.withOpacity(0.85),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: scheme.outline.withOpacity(0.18)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            thumb(),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product,
                    style: Theme.of(context).textTheme.titleMedium?.bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Line: $line • Batch: $batchId",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.65),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TraceStatusChip(status: status),
                      TraceRiskChip(riskScore: riskScore),
                      if (quantity != null)
                        chip("Qty: $quantity", Icons.scale_rounded),
                      if (createdAt != null)
                        chip(
                          DateFormatter.formatDateTime(createdAt!),
                          Icons.schedule_rounded,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: scheme.onSurface.withOpacity(0.55),
            ),
          ],
        ),
      ),
    );
  }
}
