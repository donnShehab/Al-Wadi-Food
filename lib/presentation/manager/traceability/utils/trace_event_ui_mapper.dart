import 'package:flutter/material.dart';
import 'trace_event_types.dart';

class TraceEventUi {
  final IconData icon;
  final Color color;

  const TraceEventUi({required this.icon, required this.color});
}

class TraceEventUiMapper {
  static TraceEventUi map(BuildContext context, String type) {
    final scheme = Theme.of(context).colorScheme;

    switch (type) {
      case TraceEventTypes.created:
        return TraceEventUi(
          icon: Icons.add_circle_rounded,
          color: scheme.primary,
        );
      case TraceEventTypes.sentToQc:
        return TraceEventUi(
          icon: Icons.forward_to_inbox_rounded,
          color: scheme.tertiary,
        );
      case TraceEventTypes.qcPassed:
        return const TraceEventUi(
          icon: Icons.verified_rounded,
          color: Colors.green,
        );
      case TraceEventTypes.qcFailed:
        return TraceEventUi(icon: Icons.error_rounded, color: scheme.error);
      case TraceEventTypes.approved:
        return const TraceEventUi(
          icon: Icons.check_circle_rounded,
          color: Colors.green,
        );
      case TraceEventTypes.rejected:
        return TraceEventUi(icon: Icons.block_rounded, color: Colors.red);
      case TraceEventTypes.hold:
        return TraceEventUi(
          icon: Icons.pause_circle_rounded,
          color: scheme.tertiary,
        );
      default:
        return TraceEventUi(icon: Icons.bolt_rounded, color: scheme.outline);
    }
  }
}
