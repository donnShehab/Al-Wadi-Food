import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';

class QCStepperHeader extends StatelessWidget {
  final int currentStep;

  const QCStepperHeader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _stepItem(context, title: 'Review', stepIndex: 0),
        _line(context, from: 0),
        _stepItem(context, title: 'Inspect', stepIndex: 1),
        _line(context, from: 1),
        _stepItem(context, title: 'Decide', stepIndex: 2),
      ],
    );
  }

  Widget _stepItem(
    BuildContext context, {
    required String title,
    required int stepIndex,
  }) {
    final theme = Theme.of(context);

    // This flow has 4 internal pages (0..3) but 3 visible steps:
    // Review (0), Inspect (1), Decide (2 + 3).
    final bool isActive = currentStep >= stepIndex;
    final bool isCompleted = stepIndex < 2
        ? currentStep > stepIndex
        : currentStep >= 3; // Decide completed when we reach final page

    final Color activeColor = theme.colorScheme.primary;
    final Color idleBg = theme.colorScheme.onSurface.withOpacity(0.06);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isActive ? activeColor : idleBg,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : const [],
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    key: ValueKey('check'),
                    size: 18,
                    color: Colors.white,
                  )
                : Text(
                    '${stepIndex + 1}',
                    key: ValueKey('num-$stepIndex'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant.withOpacity(0.75),
          ),
        ),
      ],
    );
  }

  Widget _line(BuildContext context, {required int from}) {
    final theme = Theme.of(context);

    final bool filled = currentStep > from;
    final Color c = filled
        ? theme.colorScheme.primary.withOpacity(0.55)
        : theme.colorScheme.onSurface.withOpacity(0.08);

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}
