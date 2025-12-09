import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:flutter/material.dart';

class BatchCard extends StatelessWidget {
  final ProductionBatchEntity batch;

  const BatchCard({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.factory),
        title: Text("${batch.product} - ${batch.batchId}"),
        subtitle: Text("${batch.line} • ${batch.status}"),
      ),
    );
  }
}
