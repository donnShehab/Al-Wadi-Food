import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:flutter/material.dart';

class ManagerBatchHeaderCard extends StatelessWidget {
  final ProductionBatchEntity batch;

  const ManagerBatchHeaderCard({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isWaiting = batch.status == "waiting_qc";
    final isFailed = batch.status == "failed";
    final isPassed = batch.status == "passed";

    Color badgeColor = Colors.grey;
    String badgeText = batch.status;

    if (isWaiting) {
      badgeColor = Colors.orange;
      badgeText = "WAITING QC";
    } else if (isFailed) {
      badgeColor = Colors.red;
      badgeText = "FAILED";
    } else if (isPassed) {
      badgeColor = Colors.green;
      badgeText = "PASSED";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary.withOpacity(0.10), Colors.white],
        ),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
            child: Icon(Icons.factory, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  batch.product,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Line: ${batch.line} • Qty: ${batch.quantity}",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: badgeColor.withOpacity(0.25)),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
