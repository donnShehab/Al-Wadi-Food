import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_qc_result_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_image_gallery.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_measurements_grid.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class TraceQcEvidenceCard extends StatelessWidget {
  final TraceQcResultEntity qc;

  const TraceQcEvidenceCard({super.key, required this.qc});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final isFail = qc.result.toLowerCase() == 'fail';
    final color = isFail ? scheme.error : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outline.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: AppSpacing.paddingMd,
        childrenPadding: AppSpacing.paddingMd,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: color.withOpacity(0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isFail ? Icons.cancel_rounded : Icons.verified_rounded,
                    size: 16,
                    color: color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isFail ? "FAIL" : "PASS",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "QC by ${qc.qcOfficerName}",
                style: Theme.of(context).textTheme.titleMedium?.bold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        children: [
          if (isFail && (qc.failureReason ?? '').trim().isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingMd,
              decoration: BoxDecoration(
                color: scheme.error.withOpacity(0.10),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: scheme.error.withOpacity(0.25)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.report_rounded, color: scheme.error),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Failure Reason",
                          style: Theme.of(context).textTheme.titleMedium?.bold
                              .copyWith(color: scheme.error),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          qc.failureReason!.trim(),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: scheme.onSurface.withOpacity(0.8),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(
            "Measurements",
            style: Theme.of(context).textTheme.titleMedium?.bold,
          ),
          const SizedBox(height: 8),
          TraceMeasurementsGrid(measurements: qc.measurements),
          const SizedBox(height: AppSpacing.md),
          Text("Images", style: Theme.of(context).textTheme.titleMedium?.bold),
          const SizedBox(height: 8),
          TraceImageGallery(imageUrls: qc.images),
        ],
      ),
    );
  }
}
