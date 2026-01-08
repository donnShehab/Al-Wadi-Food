import 'package:flutter/material.dart';

class TraceEventUi {
  final IconData icon;
  final Color color;

  const TraceEventUi({required this.icon, required this.color});
}

class TraceEventUiMapper {
  static TraceEventUi map(BuildContext context, String type) {
    final scheme = Theme.of(context).colorScheme;

    switch (type) {
      case 'CREATED':
        return TraceEventUi(
          icon: Icons.add_circle_rounded,
          color: scheme.primary,
        );
      case 'SENT_TO_QC':
        return TraceEventUi(
          icon: Icons.forward_to_inbox_rounded,
          color: scheme.tertiary,
        );
      case 'QC_PASSED':
        return const TraceEventUi(
          icon: Icons.verified_rounded,
          color: Colors.green,
        );
      case 'QC_FAILED':
        return TraceEventUi(icon: Icons.error_rounded, color: scheme.error);
      case 'APPROVED':
        return const TraceEventUi(
          icon: Icons.check_circle_rounded,
          color: Colors.green,
        );
      case 'REJECTED':
        return TraceEventUi(icon: Icons.block_rounded, color: Colors.red);
      default:
        return TraceEventUi(icon: Icons.bolt_rounded, color: scheme.outline);
    }
  }
}
