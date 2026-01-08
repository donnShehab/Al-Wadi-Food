import 'package:alwadi_food/presentation/manager/traceability/utils/trace_status_ui_mapper.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class TraceStatusChip extends StatelessWidget {
  final String status;

  const TraceStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final ui = TraceStatusUiMapper.fromStatus(context, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: ui.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: ui.color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ui.icon, size: 16, color: ui.color),
          const SizedBox(width: 6),
          Text(
            ui.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: ui.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
