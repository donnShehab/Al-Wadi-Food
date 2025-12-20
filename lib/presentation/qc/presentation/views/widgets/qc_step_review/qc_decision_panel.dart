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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Final Quality Decision',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        /// ✅ PASS / ❌ FAIL
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Text('PASS'),
                selected: passed,
                selectedColor: Colors.green,
                onSelected: (_) => onDecisionChanged(true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ChoiceChip(
                label: const Text('FAIL'),
                selected: !passed,
                selectedColor: Colors.red,
                onSelected: (_) => onDecisionChanged(false),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        /// ❌ Failure Reason
        if (!passed)
          TextFormField(
            controller: failureReasonController,
            decoration: const InputDecoration(
              labelText: 'Failure Reason *',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (v) {
              if (!passed && (v == null || v.isEmpty)) {
                return 'Failure reason is required';
              }
              return null;
            },
          ),

        const SizedBox(height: 28),

        /// 🚀 SUBMIT
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: passed ? Colors.green : Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: Icon(passed ? Icons.check_circle : Icons.cancel),
            label: Text(
              passed ? 'Approve Batch' : 'Reject Batch',
              style: const TextStyle(fontSize: 16),
            ),
            onPressed: onSubmit,
          ),
        ),
      ],
    );
  }
}
