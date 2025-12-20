import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/info_row.dart';
import 'package:alwadi_food/core/utils/date_formatter.dart';

class BatchOverviewSection extends StatelessWidget {
  final ProductionBatchEntity batch;

  const BatchOverviewSection({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.12)),
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
          /// 🔹 Section Title
          Text(
            'Batch Overview',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),

          /// 🔹 Batch Information
          InfoRow(
            label: 'Product',
            value: batch.product,
            icon: Icons.restaurant_menu,
          ),
          InfoRow(
            label: 'Batch ID',
            value: batch.batchId,
            icon: Icons.qr_code_2,
          ),
          InfoRow(
            label: 'Production Line',
            value: batch.line,
            icon: Icons.factory,
          ),
          InfoRow(
            label: 'Quantity',
            value: '${batch.quantity} units',
            icon: Icons.inventory_2,
          ),
          InfoRow(
            label: 'Operator',
            value: batch.operatorName,
            icon: Icons.engineering,
          ),

          /// 🔹 Time Info
          InfoRow(
            label: 'Start Time',
            value: DateFormatter.formatDateTime(batch.startTime),
            icon: Icons.play_circle_outline,
          ),
          InfoRow(
            label: 'End Time',
            value: batch.endTime == null
                ? 'In progress'
                : DateFormatter.formatDateTime(batch.endTime!),
            icon: Icons.stop_circle_outlined,
          ),

          /// 🔹 Notes (optional)
          if (batch.notes.isNotEmpty)
            InfoRow(
              label: 'Supervisor Notes',
              value: batch.notes,
              icon: Icons.note_alt_outlined,
            ),
        ],
      ),
    );
  }
}
