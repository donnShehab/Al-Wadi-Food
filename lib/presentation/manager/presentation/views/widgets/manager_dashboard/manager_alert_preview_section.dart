import 'package:alwadi_food/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManagerAlertPreviewSection extends StatelessWidget {
  final int highRiskAlerts;

  const ManagerAlertPreviewSection({super.key, required this.highRiskAlerts});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        if (highRiskAlerts > 0) {
          context.push(AppRouter.KManagerHighRiskAlertsView);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: highRiskAlerts > 0
              ? Colors.red.withOpacity(0.08)
              : Colors.green.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: highRiskAlerts > 0
                ? Colors.red.withOpacity(0.20)
                : Colors.green.withOpacity(0.20),
          ),
        ),
        child: Row(
          children: [
            Icon(
              highRiskAlerts > 0
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle,
              color: highRiskAlerts > 0 ? Colors.red : Colors.green,
              size: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    highRiskAlerts > 0
                        ? "$highRiskAlerts High Risk Alerts need attention"
                        : "No critical alerts today ✅",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    highRiskAlerts > 0
                        ? "Tap to view details and resolve issues."
                        : "Everything looks stable today.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (highRiskAlerts > 0)
              const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
