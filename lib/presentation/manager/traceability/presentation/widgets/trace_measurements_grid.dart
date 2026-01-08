import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class TraceMeasurementsGrid extends StatelessWidget {
  final Map<String, dynamic> measurements;

  const TraceMeasurementsGrid({super.key, required this.measurements});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (measurements.isEmpty) {
      return Text(
        "No measurements recorded.",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface.withOpacity(0.7),
        ),
      );
    }

    final entries = measurements.entries.toList();

    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withOpacity(0.28),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outline.withOpacity(0.2)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: entries.map((e) {
          return _MetricTile(label: e.key, value: "${e.value}");
        }).toList(),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const _MetricTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outline.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.bold),
        ],
      ),
    );
  }
}
