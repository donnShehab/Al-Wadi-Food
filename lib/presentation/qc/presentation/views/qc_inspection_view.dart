import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_inspection/qc_inspection_body_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QCInspectionView extends StatelessWidget {
  final String batchId;
  const QCInspectionView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'QC Inspection',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: BlocProvider.value(
        value: context.read<QCCubit>(),
        child: QCInspectionBodyBlocConsumer(batchId: batchId),
      ),
    );
}
}
