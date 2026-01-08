import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

enum TraceBannerType { info, warning, danger }

class TraceAttentionBanner extends StatelessWidget {
  final TraceBannerType type;
  final String title;
  final String message;

  const TraceAttentionBanner({
    super.key,
    required this.type,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final Color color = switch (type) {
      TraceBannerType.info => scheme.primary,
      TraceBannerType.warning => scheme.tertiary,
      TraceBannerType.danger => scheme.error,
    };

    final IconData icon = switch (type) {
      TraceBannerType.info => Icons.info_rounded,
      TraceBannerType.warning => Icons.warning_rounded,
      TraceBannerType.danger => Icons.report_rounded,
    };

    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.bold.copyWith(color: color),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withOpacity(0.75),
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
