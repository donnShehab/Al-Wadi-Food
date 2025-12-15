import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/info_row.dart';
import 'package:alwadi_food/core/utils/date_formatter.dart';

class TimeTrackingSection extends StatelessWidget {
  final ProductionBatchEntity batch;

  const TimeTrackingSection({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _sectionCard(theme, "Time Tracking", [
      InfoRow(
        label: "Start Time",
        value: DateFormatter.formatDateTime(batch.startTime),
        icon: Icons.access_time,
      ),
     InfoRow(
        label: "End Time",
        value: batch.endTime == null
            ? "In progress"
            : DateFormatter.formatDateTime(batch.endTime!),
        icon: Icons.access_time_filled,
      ),

    ]);
  }

  Widget _sectionCard(ThemeData theme, String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
