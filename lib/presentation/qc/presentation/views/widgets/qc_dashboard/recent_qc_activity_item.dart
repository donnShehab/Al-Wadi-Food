import 'package:flutter/material.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/core/utils/date_formatter.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';

class RecentQCActivityItem extends StatelessWidget {
  final QCResultEntity result;

  const RecentQCActivityItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final passed = result.result == AppConstants.qcResultPass;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
          passed ? Icons.check_circle : Icons.cancel,
          color: passed ? Colors.green : Colors.red,
        ),
        title: Text('Batch ${result.batchId}'),
        subtitle: Text(DateFormatter.formatDateTime(result.createdAt)),
        trailing: Chip(
          label: Text(
            passed ? 'PASS' : 'FAIL',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: passed ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
