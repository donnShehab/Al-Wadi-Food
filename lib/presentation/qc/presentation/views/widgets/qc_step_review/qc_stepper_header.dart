import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';

class QCStepperHeader extends StatelessWidget {
  final int currentStep;

  const QCStepperHeader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _stepItem('Review', 0, currentStep),
        _line(),
        _stepItem('Inspect', 1, currentStep),
        _line(),
        _stepItem('Decide', 2, currentStep),
      ],
    );
  }

  Widget _stepItem(String title, int step, int current) {
    final isActive = step <= current;

    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isActive ? Colors.blue : Colors.grey.shade300,
          child: Text(
            '${step + 1}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _line() {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        color: Colors.grey.shade300,
      ),
    );
  }
}

