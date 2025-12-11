import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_history/qc_history_item.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';

class QCHistoryBody extends StatelessWidget {
  final List<QCResultEntity> results;

  const QCHistoryBody({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const Center(child: Text('No QC results found'));
    }

    return ListView.builder(
      padding: AppSpacing.paddingMd,
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return QCHistoryItem(result: result);
      },
    );
  }
}

