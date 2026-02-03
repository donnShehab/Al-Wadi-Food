import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';

class QCDecisionPanel extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool passed;
  final TextEditingController failureReasonController;
  final ValueChanged<bool> onDecisionChanged;
  final VoidCallback onSubmit;

  const QCDecisionPanel({
    super.key,
    required this.formKey,
    required this.passed,
    required this.failureReasonController,
    required this.onDecisionChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final passColor = Colors.green;
    final failColor = Colors.red;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Final Quality Decision',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose PASS or FAIL, then submit the inspection.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.78),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 18),

          /// PASS / FAIL
          Row(
            children: [
              Expanded(
                child: _DecisionChip(
                  label: 'PASS',
                  icon: Icons.check_circle,
                  color: passColor,
                  selected: passed,
                  onTap: () => onDecisionChanged(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DecisionChip(
                  label: 'FAIL',
                  icon: Icons.cancel,
                  color: failColor,
                  selected: !passed,
                  onTap: () => onDecisionChanged(false),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// Failure Reason
          if (!passed) ...[
            Text(
              'Failure Reason',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: failureReasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Failure Reason *',
                filled: true,
                fillColor: theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              validator: (v) {
                if (!passed && (v == null || v.isEmpty)) {
                  return 'Failure reason is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
          ],

          /// SUBMIT
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: passed ? passColor : failColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: Icon(passed ? Icons.check_circle : Icons.cancel),
              label: Text(
                passed ? 'Approve Batch' : 'Reject Batch',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}

class _DecisionChip extends StatelessWidget {
  const _DecisionChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.12) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? color.withOpacity(0.55)
                : theme.colorScheme.onSurface.withOpacity(0.08),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ]
              : const [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? color : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: selected ? color : theme.colorScheme.onSurfaceVariant,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
