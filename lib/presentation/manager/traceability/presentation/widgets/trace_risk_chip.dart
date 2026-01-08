import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class TraceRiskChip extends StatelessWidget {
  final int riskScore;

  const TraceRiskChip({super.key, required this.riskScore});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final bool high = riskScore >= 3;
    final bool medium = riskScore == 1 || riskScore == 2;

    final Color color = high
        ? scheme.error
        : medium
        ? scheme.tertiary
        : Colors.green;

    final String label = high
        ? "High Risk"
        : medium
        ? "Attention"
        : "Normal";

    final IconData icon = high
        ? Icons.warning_rounded
        : medium
        ? Icons.info_rounded
        : Icons.check_circle_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
