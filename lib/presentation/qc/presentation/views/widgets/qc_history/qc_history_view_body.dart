import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'qc_history_item.dart';

class QCHistoryViewBody extends StatelessWidget {
  final List<QCResultEntity> results;

  const QCHistoryViewBody({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const Center(child: Text('No QC inspections found'));
    }

    return ListView.builder(
      padding: AppSpacing.paddingLg,
      itemCount: results.length,
      itemBuilder: (context, index) {
        return QCHistoryItem(result: results[index]);
      },
    );
  }
}
