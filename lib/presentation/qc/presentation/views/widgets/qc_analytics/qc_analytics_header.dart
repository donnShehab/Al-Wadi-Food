import 'package:flutter/material.dart';

class QCAnalyticsHeader extends StatelessWidget {
  final String? changeLabel;
  final String? changeValue;
  final bool? isUp;

  const QCAnalyticsHeader({
    super.key,
    this.changeLabel,
    this.changeValue,
    this.isUp,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final showChange =
        changeLabel != null && changeValue != null && isUp != null;
    final upColor = Colors.green;
    final downColor = theme.colorScheme.error;
    final accent = (isUp ?? true) ? upColor : downColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "QC Trend Analytics",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            if (showChange)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: accent.withOpacity(0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      (isUp ?? true)
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 18,
                      color: accent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "$changeValue",
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: accent,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      changeLabel!,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "Weekly quality trend monitoring (Last 7 Days)",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
