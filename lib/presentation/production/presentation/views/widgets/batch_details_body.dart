import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/images_grid.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/info_row.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/production/cubit/production_state.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/widgets/custom_button.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/utils/date_formatter.dart';
import 'package:go_router/go_router.dart';

class BatchDetailsBody extends StatelessWidget {
  final ProductionState state;
  final String batchId;

  const BatchDetailsBody({
    super.key,
    required this.state,
    required this.batchId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state is ProductionLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProductionBatchLoaded) {
      final batch = (state as ProductionBatchLoaded).batch;
      return SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoRow(label: 'Product', value: batch.product),
            InfoRow(label: 'Quantity', value: '${batch.quantity} units'),
            InfoRow(label: 'Line', value: batch.line),
            InfoRow(label: 'Operator', value: batch.operatorName),
            InfoRow(label: 'Status', value: batch.status.toUpperCase()),
            InfoRow(
              label: 'Start Time',
              value: DateFormatter.formatDateTime(batch.startTime),
            ),
            InfoRow(
              label: 'End Time',
              value: DateFormatter.formatDateTime(batch.endTime),
            ),
            InfoRow(label: 'Notes', value: batch.notes),
            const SizedBox(height: AppSpacing.lg),
            Text('Images', style: theme.textTheme.titleMedium?.semiBold),
            const SizedBox(height: AppSpacing.sm),
            batch.images.isNotEmpty
                ? ImagesGrid(urls: batch.images)
                : const Text('No images available'),
            const SizedBox(height: 32),
            if (batch.status == 'in_progress')
              CustomButton(
                text: 'Send to QC',
                onPressed: () =>
                    context.read<ProductionCubit>().sendToQC(batchId),
                backgroundColor: theme.colorScheme.secondary,
                icon: Icons.send,
              ),
            const SizedBox(height: AppSpacing.md),
            CustomButton(
              text: 'View QC History',
              onPressed: () => context.push('/qc-history/$batchId'),
              isOutlined: true,
              icon: Icons.history,
            ),
          ],
        ),
      );
    } else if (state is ProductionError) {
      final errorState = state as ProductionError;
      return Center(child: Text(errorState.message));
    }

    return const SizedBox();
  }
}
