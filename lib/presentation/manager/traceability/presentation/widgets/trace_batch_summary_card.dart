// import 'package:alwadi_food/core/utils/date_formatter.dart';
// import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_status_chip.dart';
// import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_batch_entity.dart';
// import 'package:alwadi_food/theme.dart';
// import 'package:flutter/material.dart';

// class TraceBatchSummaryCard extends StatelessWidget {
//   final TraceBatchEntity batch;

//   const TraceBatchSummaryCard({super.key, required this.batch});

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;
//     final thumb = batch.images.isNotEmpty ? batch.images.first : null;

//     Widget thumbWidget() {
//       if (thumb == null || thumb.trim().isEmpty) {
//         return Container(
//           width: 68,
//           height: 68,
//           decoration: BoxDecoration(
//             color: scheme.primary.withOpacity(0.08),
//             borderRadius: BorderRadius.circular(AppRadius.lg),
//             border: Border.all(color: scheme.outline.withOpacity(0.2)),
//           ),
//           child: Icon(
//             Icons.inventory_2_rounded,
//             color: scheme.primary.withOpacity(0.7),
//             size: 30,
//           ),
//         );
//       }

//       return ClipRRect(
//         borderRadius: BorderRadius.circular(AppRadius.lg),
//         child: Image.network(
//           thumb,
//           width: 68,
//           height: 68,
//           fit: BoxFit.cover,
//           errorBuilder: (_, __, ___) => Container(
//             width: 68,
//             height: 68,
//             decoration: BoxDecoration(
//               color: scheme.surfaceContainerHighest.withOpacity(0.6),
//               borderRadius: BorderRadius.circular(AppRadius.lg),
//             ),
//             child: Icon(
//               Icons.broken_image_rounded,
//               color: scheme.onSurface.withOpacity(0.6),
//             ),
//           ),
//         ),
//       );
//     }

//     return Container(
//       padding: AppSpacing.paddingMd,
//       decoration: BoxDecoration(
//         color: scheme.surface,
//         borderRadius: BorderRadius.circular(AppRadius.lg),
//         border: Border.all(color: scheme.outline.withOpacity(0.18)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           thumbWidget(),
//           const SizedBox(width: AppSpacing.md),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   batch.product,
//                   style: Theme.of(context).textTheme.titleLarge?.bold,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "Line: ${batch.line} • Batch: ${batch.batchId}",
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: scheme.onSurface.withOpacity(0.65),
//                   ),
//                 ),
//                 const SizedBox(height: AppSpacing.sm),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: [
//                     TraceStatusChip(status: batch.status),
//                     _chip(
//                       context,
//                       "Qty: ${batch.quantity}",
//                       Icons.scale_rounded,
//                     ),
//                     _chip(
//                       context,
//                       DateFormatter.formatDateTime(batch.createdAt),
//                       Icons.schedule_rounded,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _chip(BuildContext context, String text, IconData icon) {
//     final scheme = Theme.of(context).colorScheme;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: scheme.surfaceContainerHighest.withOpacity(0.35),
//         borderRadius: BorderRadius.circular(AppRadius.xl),
//         border: Border.all(color: scheme.outline.withOpacity(0.2)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 16, color: scheme.onSurface.withOpacity(0.7)),
//           const SizedBox(width: 6),
//           Text(
//             text,
//             style: Theme.of(context).textTheme.labelLarge?.copyWith(
//               color: scheme.onSurface.withOpacity(0.85),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
