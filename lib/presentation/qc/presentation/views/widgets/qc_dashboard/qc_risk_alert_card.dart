import 'package:flutter/material.dart';

class QCRiskAlertCard extends StatelessWidget {
  final String riskLevel;

  const QCRiskAlertCard({super.key, required this.riskLevel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color bgColor;
    Color borderColor;
    IconData icon;
    String title;
    String subtitle;

    switch (riskLevel) {
      case "high":
        bgColor = Colors.red.withOpacity(0.08);
        borderColor = Colors.red.withOpacity(0.35);
        icon = Icons.warning_rounded;
        title = "High Quality Risk";
        subtitle = "Multiple failures detected today. Action required!";
        break;

      case "medium":
        bgColor = Colors.orange.withOpacity(0.08);
        borderColor = Colors.orange.withOpacity(0.35);
        icon = Icons.report_problem_rounded;
        title = "Medium Risk";
        subtitle = "Some issues detected. Monitor closely.";
        break;

      default:
        bgColor = Colors.green.withOpacity(0.08);
        borderColor = Colors.green.withOpacity(0.35);
        icon = Icons.verified_rounded;
        title = "Low Risk";
        subtitle = "Quality stable. No major issues.";
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: borderColor,
            child: Icon(icon, color: borderColor.withOpacity(0.9), size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
