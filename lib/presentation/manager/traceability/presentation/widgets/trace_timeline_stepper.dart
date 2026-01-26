// import 'package:alwadi_food/core/utils/date_formatter.dart';
// import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_event_entity.dart';
// import 'package:alwadi_food/presentation/manager/traceability/utils/trace_event_ui_mapper.dart';
// import 'package:alwadi_food/theme.dart';
// import 'package:flutter/material.dart';

// class TraceTimelineStepper extends StatelessWidget {
//   final List<TraceEventEntity> events;

//   const TraceTimelineStepper({super.key, required this.events});

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;

//     if (events.isEmpty) {
//       return Container(
//         padding: AppSpacing.paddingMd,
//         decoration: BoxDecoration(
//           color: scheme.surface,
//           borderRadius: BorderRadius.circular(AppRadius.lg),
//           border: Border.all(color: scheme.outline.withOpacity(0.18)),
//         ),
//         child: Text(
//           "No trace events found yet.",
//           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//             color: scheme.onSurface.withOpacity(0.7),
//           ),
//         ),
//       );
//     }

//     final sorted = [...events]
//       ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
//     final latestId = sorted.last.id;

//     return Container(
//       padding: AppSpacing.paddingMd,
//       decoration: BoxDecoration(
//         color: scheme.surface,
//         borderRadius: BorderRadius.circular(AppRadius.lg),
//         border: Border.all(color: scheme.outline.withOpacity(0.18)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         children: List.generate(sorted.length, (i) {
//           final e = sorted[i];
//           final isLast = i == sorted.length - 1;
//           final isLatest = e.id == latestId;
//           final ui = TraceEventUiMapper.map(context, e.type);

//           return _TraceStepTile(
//             icon: ui.icon,
//             color: ui.color,
//             title: e.title,
//             description: e.description,
//             timestamp: DateFormatter.formatDateTime(e.timestamp),
//             actor: "${e.actorName} • ${e.actorRole}",
//             isLast: isLast,
//             highlight: isLatest,
//           );
//         }),
//       ),
//     );
//   }
// }

// class _TraceStepTile extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final String title;
//   final String description;
//   final String timestamp;
//   final String actor;
//   final bool isLast;
//   final bool highlight;

//   const _TraceStepTile({
//     required this.icon,
//     required this.color,
//     required this.title,
//     required this.description,
//     required this.timestamp,
//     required this.actor,
//     required this.isLast,
//     required this.highlight,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             Container(
//               width: 34,
//               height: 34,
//               decoration: BoxDecoration(
//                 color: color.withOpacity(highlight ? 0.18 : 0.12),
//                 shape: BoxShape.circle,
//                 border: Border.all(color: color.withOpacity(0.35)),
//               ),
//               child: Icon(icon, color: color, size: 18),
//             ),
//             if (!isLast)
//               Container(
//                 width: 2,
//                 height: 46,
//                 margin: const EdgeInsets.symmetric(vertical: 6),
//                 decoration: BoxDecoration(
//                   color: scheme.outline.withOpacity(0.25),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//           ],
//         ),
//         const SizedBox(width: AppSpacing.md),
//         Expanded(
//           child: Container(
//             margin: const EdgeInsets.only(bottom: AppSpacing.md),
//             padding: const EdgeInsets.symmetric(vertical: 2),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         title,
//                         style: Theme.of(context).textTheme.titleMedium?.bold
//                             .copyWith(
//                               color: highlight ? color : scheme.onSurface,
//                             ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       timestamp,
//                       style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         color: scheme.onSurface.withOpacity(0.6),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   "by $actor",
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     color: scheme.onSurface.withOpacity(0.65),
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   description.isEmpty ? "—" : description,
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: scheme.onSurface.withOpacity(0.75),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
