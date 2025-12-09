import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BatchListItem extends StatelessWidget {
  final dynamic batch;
  const BatchListItem({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: Icon(Icons.inventory_2, color: theme.colorScheme.primary),
        title: Text(batch.product),
        subtitle: Text(
          '${batch.quantity} units • ${batch.line} • ${batch.status}',
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => context.push('/batch-details/${batch.batchId}'),
      ),
    );
  }
}
