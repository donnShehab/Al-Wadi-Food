import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';

class StatusTimeline extends StatelessWidget {
  final int currentStep; // 0..3

  const StatusTimeline({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const steps = ["Planned", "In Progress", "Waiting QC", "Completed"];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isActive = index <= currentStep;
          final isCurrent = index == currentStep;

          final color = isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.5);

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index != 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                    Container(
                      width: isCurrent ? 18 : 14,
                      height: isCurrent ? 18 : 14,
                      decoration: BoxDecoration(
                        color: isActive ? color : theme.colorScheme.background,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: color, width: 2),
                      ),
                    ),
                    if (index != steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index < currentStep
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withOpacity(0.3),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  steps[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
