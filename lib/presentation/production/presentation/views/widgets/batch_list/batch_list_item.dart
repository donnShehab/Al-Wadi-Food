// import 'package:alwadi_food/core/constants/app_constants.dart';
// import 'package:alwadi_food/presentation/animations/animated_status_badge.dart';
// import 'package:alwadi_food/presentation/animations/pressable_card.dart';
// import 'package:alwadi_food/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class BatchListItem extends StatefulWidget {
//   final dynamic batch;
//   const BatchListItem({super.key, required this.batch});

//   @override
//   State<BatchListItem> createState() => _BatchListItemState();
// }

// class _BatchListItemState extends State<BatchListItem> {
//   Color getStatusColor(String status) {
//     switch (status) {
//       case AppConstants.statusInProgress:
//         return Colors.blue;
//       case AppConstants.statusWaitingQC:
//         return Colors.orange;
//       case AppConstants.statusPassed:
//         return Colors.green;
//       case AppConstants.statusFailed:
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   Widget buildStatusBadge(String status) {
//     final color = getStatusColor(status);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.4)),
//       ),
//       child: Text(
//         status.replaceAll('_', ' ').toUpperCase(),
//         style: TextStyle(
//           color: color,
//           fontWeight: FontWeight.bold,
//           fontSize: 11,
//           letterSpacing: 0.5,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return PressableScale(
//       onTap: () => context.push('/batch-details/${widget.batch.batchId}'),
//       child: Card(
//         elevation: 2.5,
//         margin: const EdgeInsets.only(bottom: AppSpacing.sm),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppRadius.md),
//         ),

//         child: Padding(
//           padding: const EdgeInsets.all(14),
//           child: Row(
//             children: [
//               /// -------- Icon / Avatar (مع Hero للأنيميشن مع شاشة التفاصيل) --------
//               Hero(
//                 tag: "batch_${widget.batch.batchId}",
//                 child: Container(
//                   width: 46,
//                   height: 46,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [
//                         theme.colorScheme.primary,
//                         theme.colorScheme.primary.withOpacity(0.7),
//                       ],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                   ),
//                   child: const Icon(
//                     Icons.restaurant_menu,
//                     color: Colors.white,
//                     size: 24,
//                   ),
//                 ),
//               ),

//               const SizedBox(width: 14),

//               /// -------- Main Info --------
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     /// Top row: product + status badge
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             widget.batch.product,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: theme.textTheme.titleMedium?.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         // buildStatusBadge(batch.status),
//                         AnimatedStatusBadge(
//                           status: widget.batch.status,
//                           color: getStatusColor(widget.batch.status),
//                           enableAnimation:
//                               widget.batch.status == AppConstants.statusInProgress ||
//                               widget.batch.status == AppConstants.statusWaitingQC,
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 6),

//                     /// Middle row: line + quantity
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.factory,
//                           size: 16,
//                           color: theme.colorScheme.primary,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(widget.batch.line, style: theme.textTheme.bodySmall),
//                         const SizedBox(width: 12),
//                         Icon(
//                           Icons.inventory_2,
//                           size: 16,
//                           color: theme.colorScheme.primary,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           '${widget.batch.quantity} units',
//                           style: theme.textTheme.bodySmall,
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 6),

//                     /// Bottom row: Batch ID
//                     Text(
//                       'Batch ID: ${widget.batch.batchId}',
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: theme.colorScheme.onSurfaceVariant,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 8),

//               /// -------- Arrow Icon --------
//               Icon(
//                 Icons.arrow_forward_ios,
//                 size: 16,
//                 color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
// }
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

  // ================= COLORS =================

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

  // ================= DELETE CONFIRM =================

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

  // ================= CARD UI =================

  Widget _buildCard(BuildContext context) {
    final theme = Theme.of(context);
    final canDelete = batch.status == AppConstants.statusInProgress;

    return PressableScale(
      onTap: () => context.push('/batch-details/${batch.batchId}'),
      child: Card(
        elevation: 2.5,
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              /// Avatar
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
                        theme.colorScheme.primary.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              /// Main Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Product + Status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            batch.product,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedStatusBadge(
                          status: batch.status,
                          color: getStatusColor(batch.status),
                          enableAnimation:
                              batch.status == AppConstants.statusInProgress ||
                              batch.status == AppConstants.statusWaitingQC,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// Line + Quantity
                    Row(
                      children: [
                        Icon(
                          Icons.factory,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(batch.line, style: theme.textTheme.bodySmall),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.inventory_2,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${batch.quantity} units',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// Batch ID
                    Text(
                      'Batch ID: ${batch.batchId}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              /// DELETE ICON
              if (canDelete)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
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
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= BUILD =================

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
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 26),
      ),
      child: _buildCard(context),
    );
  }
}
