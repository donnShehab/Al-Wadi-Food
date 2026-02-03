import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/animations/animated_status_badge.dart';
import 'package:alwadi_food/presentation/animations/pressable_card.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';

class BatchListItem extends StatelessWidget {
  final dynamic batch;

  const BatchListItem({super.key, required this.batch});

  Color getStatusColor(String status) {
    switch (status) {
      case AppConstants.statusInProgress:
        return Colors.blue;
      case AppConstants.statusWaitingQC:
        return Colors.orange;
      case AppConstants.statusPassed:
        return Colors.green;
      case AppConstants.statusFailed:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete Batch'),
            content: const Text(
              'This batch will be permanently deleted.\nThis action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildCard(BuildContext context) {
    final theme = Theme.of(context);
    final canDelete = batch.status == AppConstants.statusInProgress;

    final statusColor = getStatusColor(batch.status);
    final surface = theme.colorScheme.surface;
    final border = theme.colorScheme.onSurface.withOpacity(0.08);

    return PressableScale(
      onTap: () => context.push('/batch-details/${batch.batchId}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            // ===== Status accent rail (ERP feel) =====
            Container(
              width: 6,
              height: 92,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.90),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Avatar
                    Hero(
                      tag: "batch_${batch.batchId}",
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withOpacity(0.72),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.restaurant_menu,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Main info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  batch.product,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedStatusBadge(
                                status: batch.status,
                                color: statusColor,
                                enableAnimation:
                                    batch.status ==
                                        AppConstants.statusInProgress ||
                                    batch.status ==
                                        AppConstants.statusWaitingQC,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Icon(
                                Icons.factory,
                                size: 16,
                                color: theme.colorScheme.primary.withOpacity(
                                  0.9,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  batch.line,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant
                                        .withOpacity(0.85),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.inventory_2,
                                size: 16,
                                color: theme.colorScheme.primary.withOpacity(
                                  0.9,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${batch.quantity} units',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withOpacity(0.85),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Batch ID: ${batch.batchId}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withOpacity(0.70),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Actions
                    if (canDelete)
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          final confirm = await _confirmDelete(context);
                          if (confirm) {
                            context.read<ProductionCubit>().deleteBatch(
                              batch.batchId,
                            );
                          }
                        },
                      )
                    else
                      Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(
                          0.55,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canDelete = batch.status == AppConstants.statusInProgress;

    if (!canDelete) {
      return _buildCard(context);
    }

    return Dismissible(
      key: ValueKey(batch.batchId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {
        context.read<ProductionCubit>().deleteBatch(batch.batchId);
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 26),
      ),
      child: _buildCard(context),
    );
  }
}
