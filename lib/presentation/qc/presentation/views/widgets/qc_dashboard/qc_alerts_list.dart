import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_alert_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QCAlertsList extends StatelessWidget {
  final List<QCAlertEntity> alerts;

  const QCAlertsList({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (alerts.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "QC Alerts",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        ...alerts.map(
          (alert) => InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              /// ✅ Tap => open Batch Details
              context.push("${AppRouter.KbatchDetailsView}/${alert.batchId}");
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _bgColor(alert.severity),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor(alert.severity)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ✅ Severity Icon
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: _iconBg(alert.severity),
                    child: Icon(
                      _severityIcon(alert.severity),
                      color: _iconColor(alert.severity),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  /// ✅ Alert Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ✅ Batch Label
                        Text(
                          alert.batchLabel,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),

                        /// ✅ Reason
                        Text(
                          alert.reason,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// ✅ Action
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.75),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.80),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                size: 18,
                                color: _iconColor(alert.severity),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  alert.action,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// ✅ Severity Chip
                  _severityChip(theme, alert.severity),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ✅ UI Helpers
  // ============================================================

  Widget _severityChip(ThemeData theme, String severity) {
    final color = _iconColor(severity);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        severity.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  IconData _severityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case "high":
        return Icons.warning_amber_rounded;
      case "medium":
        return Icons.report_problem_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }

  Color _iconColor(String severity) {
    switch (severity.toLowerCase()) {
      case "high":
        return Colors.red;
      case "medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Color _iconBg(String severity) => _iconColor(severity).withOpacity(0.15);

  Color _bgColor(String severity) {
    switch (severity.toLowerCase()) {
      case "high":
        return const Color(0xFFFFF2F2);
      case "medium":
        return const Color(0xFFFFF7E6);
      default:
        return const Color(0xFFF0FFF4);
    }
  }

  Color _borderColor(String severity) {
    switch (severity.toLowerCase()) {
      case "high":
        return const Color(0xFFFFB3B3);
      case "medium":
        return const Color(0xFFFFD27A);
      default:
        return const Color(0xFF9EE6B4);
    }
  }
}
