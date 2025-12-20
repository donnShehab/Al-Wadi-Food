import 'package:alwadi_food/presentation/qc/cubit/qc_review/qc_batch_review_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_review/qc_batch_review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/images_grid.dart';

class QCStepReview extends StatelessWidget {
  final String batchId;

  const QCStepReview({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QCBatchReviewCubit>()..loadBatch(batchId),
      child: BlocBuilder<QCBatchReviewCubit, QCBatchReviewState>(
        builder: (context, state) {
          if (state is QCBatchReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QCBatchReviewError) {
            return _errorCard(state.message);
          }

          if (state is! QCBatchReviewLoaded) {
            return const SizedBox();
          }

          final batch = state.batch;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              const SizedBox(height: 14),

              _infoCard(context, batch),

              const SizedBox(height: 18),

              Text(
                'Production Images',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),

              if (batch.images.isEmpty)
                Text(
                  'No production images uploaded.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              else
                ImagesGrid(urls: batch.images),

              const SizedBox(height: 12),

              _hint(context),
            ],
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.fact_check, color: Colors.blue, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Step 1: Review Batch',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context, ProductionBatchEntity batch) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Batch Summary',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),

          _row(
            context,
            icon: Icons.restaurant_menu,
            label: 'Product',
            value: batch.product,
          ),
          _row(context, icon: Icons.factory, label: 'Line', value: batch.line),
          _row(
            context,
            icon: Icons.inventory_2,
            label: 'Quantity',
            value: '${batch.quantity} units',
          ),
          _row(
            context,
            icon: Icons.engineering,
            label: 'Operator',
            value: batch.operatorName,
          ),

          if (batch.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            _row(
              context,
              icon: Icons.note_alt_outlined,
              label: 'Notes',
              value: batch.notes,
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 18, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hint(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Review the production details and images before recording measurements.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorCard(String message) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.red)),
    );
  }
}
