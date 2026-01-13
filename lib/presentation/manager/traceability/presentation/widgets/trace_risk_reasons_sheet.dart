import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';

class TraceRiskReasonsSheet extends StatelessWidget {
  final int riskScore;
  final String riskLabel;
  final List<String> reasons;

  const TraceRiskReasonsSheet({
    super.key,
    required this.riskScore,
    required this.riskLabel,
    required this.reasons,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Risk breakdown',
                    style: Theme.of(context).textTheme.titleLarge?.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withOpacity(0.35),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: scheme.outline.withOpacity(0.18)),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield_rounded, color: scheme.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Risk $riskScore ($riskLabel)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (reasons.isEmpty)
              Text(
                'No risk reasons found.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface.withOpacity(0.75),
                ),
              )
            else
              ...reasons.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: scheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          r,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
