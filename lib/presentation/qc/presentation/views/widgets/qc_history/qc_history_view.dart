import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_history/qc_history_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class QCHistoryView extends StatelessWidget {
  final String batchId;

  const QCHistoryView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QC Inspection History')),
      body: QCHistoryViewBodyBlocConsumer(batchId: batchId),
    );
  }
}
