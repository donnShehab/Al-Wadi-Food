import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'qc_inspection_body.dart';

import 'package:go_router/go_router.dart';

class QCInspectionBodyBlocConsumer extends StatelessWidget {
  final String batchId;

  const QCInspectionBodyBlocConsumer({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QCCubit, QCState>(
      listener: (context, state) {
        if (state is QCSuccess) {
           // ✅ 1. حدّث Pending QC List فورًا
            context.read<QCCubit>().loadPendingBatches();
          try {
              // ✅ 2. حدّث Dashboard 
            context.read<QCCubit>().loadQCDashboard();
          } catch (_) {}

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));

          context.pop(true);
        } else if (state is QCError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return QCInspectionViewBody(
          batchId: batchId,
          isLoading: state is QCLoading,
        );
      },
    );
  }
}
