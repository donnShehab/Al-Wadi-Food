import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';

class QCHistoryCard extends StatelessWidget {
  final QCResultEntity result;

  const QCHistoryCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isPass = result.result == AppConstants.qcResultPass;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPass ? Colors.green : Colors.red,
          child: Icon(isPass ? Icons.check : Icons.close, color: Colors.white),
        ),
        title: Text('Batch: ${result.batchId}'),
        subtitle: Text(
          '${result.inspectorName} • ${result.createdAt.toLocal()}',
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // ⏭ نضيفها لاحقًا: QC Result Details
        },
      ),
    );
  }
}
