import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'batch_list/batch_list_item.dart';

class BatchListViewBody extends StatelessWidget {
  final List batches;
  const BatchListViewBody({super.key, required this.batches});

  @override
  Widget build(BuildContext context) {
    if (batches.isEmpty) {
      return const Center(child: Text('No batches found'));
    }

    return ListView.builder(
      padding: AppSpacing.paddingMd,
      itemCount: batches.length,
      itemBuilder: (context, index) {
        final batch = batches[index];
        return BatchListItem(batch: batch);
      },
    );
  }
}
