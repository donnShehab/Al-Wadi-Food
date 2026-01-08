import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class TraceLoadingState extends StatelessWidget {
  final String title;
  final String subtitle;

  const TraceLoadingState({
    super.key,
    this.title = "Loading traceability...",
    this.subtitle = "Please wait while we fetch batch data and evidence.",
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        margin: AppSpacing.paddingLg,
        padding: AppSpacing.paddingLg,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withOpacity(0.35),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: scheme.outline.withOpacity(0.25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: Theme.of(context).textTheme.titleMedium?.bold),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
