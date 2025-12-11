import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// class BatchListItem extends StatelessWidget {
//   final dynamic batch;
//   const BatchListItem({super.key, required this.batch});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Card(
//       margin: const EdgeInsets.only(bottom: AppSpacing.md),
//       child: ListTile(
//         leading: Icon(Icons.inventory_2, color: theme.colorScheme.primary),
//         title: Text(batch.product),
//         subtitle: Text(
//           '${batch.quantity} units • ${batch.line} • ${batch.status}',
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: () => context.push('/batch-details/${batch.batchId}'),
//       ),
//     );
//   }
// }

class BatchListItem extends StatelessWidget {
  final dynamic batch;
  const BatchListItem({super.key, required this.batch});

  Color getStatusColor(String status) {
    switch (status) {
      case AppConstants.statusInProgress:
        return Colors.blue;
      case AppConstants.statusWaitingQC:
        return Colors.orange;
      case AppConstants.statusPassed:
        return Colors.green;
      case AppConstants.statusFailed:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget buildStatusBadge(String status) {
    final color = getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: Icon(Icons.inventory_2, color: theme.colorScheme.primary),

        title: Text(batch.product),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${batch.quantity}  • ${batch.line}'),
            const SizedBox(height: 6),
            buildStatusBadge(batch.status),
          ],
        ),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

        onTap: () => context.push('/batch-details/${batch.batchId}'),
      ),
    );
  }
}
