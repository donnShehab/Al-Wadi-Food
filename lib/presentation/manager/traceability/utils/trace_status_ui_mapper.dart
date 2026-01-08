import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class TraceStatusUi {
  final String label;
  final IconData icon;
  final Color color;

  const TraceStatusUi({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class TraceStatusUiMapper {
  static TraceStatusUi fromStatus(BuildContext context, String status) {
    final scheme = Theme.of(context).colorScheme;

    switch (status) {
      case AppConstants.statusInProgress:
        return TraceStatusUi(
          label: 'In Progress',
          icon: Icons.factory_rounded,
          color: scheme.primary,
        );
      case AppConstants.statusWaitingQC:
        return TraceStatusUi(
          label: 'Waiting QC',
          icon: Icons.hourglass_bottom_rounded,
          color: scheme.tertiary,
        );
      case AppConstants.statusPassed:
        return TraceStatusUi(
          label: 'Passed',
          icon: Icons.verified_rounded,
          color: Colors.green,
        );
      case AppConstants.statusFailed:
        return TraceStatusUi(
          label: 'Failed',
          icon: Icons.cancel_rounded,
          color: scheme.error,
        );
      default:
        return TraceStatusUi(
          label: status.isEmpty ? 'Unknown' : status,
          icon: Icons.help_rounded,
          color: scheme.outline,
        );
    }
  }
}
