import 'package:flutter/material.dart';

import 'package:alwadi_food/theme.dart';
import '../../domain/entities/trace_bundle_entity.dart';
import 'trace_attention_banner.dart';

/// Evidence Summary (Mini Card)
///
/// Shows at-a-glance:
/// - image count
/// - measurement fields count
/// - failure reason snippet (if any)
/// - evidence quality: good / missing
class TraceEvidenceSummaryCard extends StatelessWidget {
  final TraceBundleEntity bundle;

  const TraceEvidenceSummaryCard({super.key, required this.bundle});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final qc = bundle.qcResults.isNotEmpty ? bundle.qcResults.first : null;
    final failureReason = qc?.failureReason?.trim();

    final batchImages =
        bundle.batch.images.where((e) => e.trim().isNotEmpty).length;
    final qcImages =
        qc == null ? 0 : qc.images.where((e) => e.trim().isNotEmpty).length;
    final imagesTotal = batchImages + qcImages;

    final measurementCount = qc == null ? 0 : qc.measurements.keys.length;

    final bool needsEvidence = bundle.isFailed;
    final bool missingFailureReason =
        needsEvidence && (failureReason == null || failureReason.isEmpty);
    final bool missingImages = needsEvidence && imagesTotal == 0;

    final bool evidenceOk = !(missingFailureReason || missingImages);

    final banner = (needsEvidence && !evidenceOk)
        ? TraceAttentionBanner(
            type: TraceBannerType.warning,
            title: 'Evidence Missing',
            message: _missingMessage(missingFailureReason, missingImages),
          )
        : null;

    return Column(
      children: [
        if (banner != null) ...[
          banner,
          const SizedBox(height: AppSpacing.md),
        ],
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: scheme.outline.withOpacity(0.25)),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 5),
                color: Color(0x10000000),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.inventory_2_rounded, color: scheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Evidence Summary',
                      style: Theme.of(context).textTheme.titleMedium?.bold,
                    ),
                  ),
                  _qualityPill(context, evidenceOk: evidenceOk),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _statChip(
                    context,
                    icon: Icons.photo_library_rounded,
                    label: 'Images: $imagesTotal',
                  ),
                  _statChip(
                    context,
                    icon: Icons.straighten_rounded,
                    label: 'Measurements: $measurementCount',
                  ),
                  if (bundle.isFailed)
                    _statChip(
                      context,
                      icon: Icons.report_problem_rounded,
                      label: failureReason == null || failureReason.isEmpty
                          ? 'Failure reason: -'
                          : 'Failure: ${_shorten(failureReason, 48)}',
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _missingMessage(bool missingFailureReason, bool missingImages) {
    final parts = <String>[];
    if (missingFailureReason) parts.add('failureReason');
    if (missingImages) parts.add('at least 1 image');
    return 'QC failed but missing: ${parts.join(' and ')}. Ask QC to complete evidence.';
  }

  String _shorten(String s, int max) {
    final t = s.trim();
    if (t.length <= max) return t;
    return '${t.substring(0, max - 1)}…';
  }

  Widget _qualityPill(BuildContext context, {required bool evidenceOk}) {
    final scheme = Theme.of(context).colorScheme;
    final color = evidenceOk ? Colors.green : scheme.tertiary;
    final icon =
        evidenceOk ? Icons.check_circle_rounded : Icons.warning_rounded;
    final label = evidenceOk ? 'Good' : 'Missing';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withOpacity(0.35),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.outline.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: scheme.onSurface.withOpacity(0.75)),
          const SizedBox(width: 10),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
