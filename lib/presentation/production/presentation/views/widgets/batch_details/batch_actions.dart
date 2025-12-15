import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BatchActions extends StatelessWidget {
  final ProductionBatchEntity batch;
  final String batchId;

  const BatchActions({super.key, required this.batch, required this.batchId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        /// 🔴 Close Batch (only when in progress)
        if (batch.status == "in_progress") ...[
          CustomButton(
            text: "Close Batch",
            backgroundColor: theme.colorScheme.error,
            icon: Icons.stop_circle,
            onPressed: () {
              context.read<ProductionCubit>().closeBatch(batch);
            },
          ),
          const SizedBox(height: 12),
        ],

        /// Send to QC (اختياري نخليه أو نشيله لاحقاً)
        if (batch.status == "waiting_qc") ...[
          CustomButton(
            text: "Send to QC",
            backgroundColor: theme.colorScheme.secondary,
            icon: Icons.send,
            onPressed: () => context.read<ProductionCubit>().sendToQC(batchId),
          ),
          const SizedBox(height: 12),
        ],

        CustomButton(
          text: "View QC History",
          isOutlined: true,
          icon: Icons.history,
          onPressed: () => context.push("/qc-history/$batchId"),
        ),
      ],
    );
  }
}
