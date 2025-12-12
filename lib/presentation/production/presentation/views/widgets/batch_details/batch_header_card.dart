import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';

class BatchHeaderCard extends StatelessWidget {
  final ProductionBatchEntity batch;

  const BatchHeaderCard({super.key, required this.batch});

  Color statusColor(String status) {
    switch (status) {
      case "passed":
        return Colors.green;
      case "failed":
        return Colors.red;
      case "waiting_qc":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Hero(
            tag: "batch_${batch.batchId}",
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.restaurant_menu,
                size: 32,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  batch.product,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Batch ID: ${batch.batchId}",
                  style: TextStyle(color: Colors.white.withOpacity(0.90)),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              batch.status.replaceAll("_", " ").toUpperCase(),
              style: TextStyle(
                color: statusColor(batch.status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
