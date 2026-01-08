import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'qc_details_view_body_bloc_consumer.dart';

class QCDetailsView extends StatelessWidget {
  final String inspectionId;

  const QCDetailsView({super.key, required this.inspectionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QCCubit>()..loadQCResultByInspectionId(inspectionId),
      child: Scaffold(
        appBar: AppBar(title: const Text("QC Inspection Details")),
        body: QCDetailsViewBodyBlocConsumer(inspectionId: inspectionId),
      ),
    );
  }
}
