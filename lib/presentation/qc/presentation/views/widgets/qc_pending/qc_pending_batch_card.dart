import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alwadi_food/theme.dart';

class QCPendingBatchCard extends StatelessWidget {
  final dynamic batch; // استبدل dynamic بالنوع الصحيح إذا كان لديك BatchEntity

  const QCPendingBatchCard({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: Icon(
          Icons.assignment,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        title: Text(batch.product),
        subtitle: Text('${batch.quantity} units • ${batch.line}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => context.push('/qc-inspection/${batch.batchId}'),
      ),
    );
  }
}
