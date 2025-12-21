import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_details/qc_details_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';

class QCDetailsView extends StatelessWidget {
  final String inspectionId;

  const QCDetailsView({super.key, required this.inspectionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QC Inspection Details')),
      body: QCDetailsViewBodyBlocConsumer(inspectionId: inspectionId),
    );
  }
}
