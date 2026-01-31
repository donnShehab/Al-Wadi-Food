import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';

class ExecutiveCard extends StatelessWidget {
  const ExecutiveCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = AppRadius.xl, // 24
  });

  final Widget child;
  final EdgeInsets? padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final surface = theme.colorScheme.surface;
    final outline = theme.colorScheme.onSurface.withOpacity(0.06);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        // Subtle “executive” surface gradient
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.lerp(surface, Colors.white, 0.10) ?? surface, surface],
        ),
        border: Border.all(color: outline, width: 1),
        boxShadow: [
          // Wide, soft shadow (premium)
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
          // Tiny brand-tinted lift
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
            spreadRadius: -6,
          ),
        ],
      ),
      child: Padding(
        padding:
            padding ??
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, // 24
              vertical: 22,
            ),
        child: child,
      ),
    );
  }
}
