import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_state.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_pending/qc_pending_batch_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/theme.dart';

class QCPendingListBodyBlocConsumer extends StatelessWidget {
  const QCPendingListBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QCCubit, QCState>(
      listener: (context, state) {
        // يمكنك إضافة Snackbar أو أي تفاعل عند حدوث خطأ أو نجاح
        if (state is QCError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is QCLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is QCPendingBatchesLoaded) {
          if (state.batches.isEmpty) {
            return const Center(child: Text('No pending inspections'));
          }
          return ListView.builder(
            padding: AppSpacing.paddingMd,
            itemCount: state.batches.length,
            itemBuilder: (context, index) {
              final batch = state.batches[index];
              return QCPendingBatchCard(batch: batch);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
