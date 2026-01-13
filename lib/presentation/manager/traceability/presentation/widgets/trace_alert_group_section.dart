import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';

class TraceAlertGroupSection extends StatelessWidget {
  final String title;
  final int count;
  final Widget child;

  const TraceAlertGroupSection({
    super.key,
    required this.title,
    required this.count,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withOpacity(0.35),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: scheme.outline.withOpacity(0.18)),
              ),
              child: Text(
                '$count',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        child,
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
