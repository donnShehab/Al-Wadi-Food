// import 'package:flutter/material.dart';
// import 'package:alwadi_food/theme.dart';

// import '../../domain/entities/trace_alert_entity.dart';
// import '../../utils/trace_fallbacks.dart';

// typedef NoteCallback = Future<void> Function(String note);

// class TraceAlertCard extends StatelessWidget {
//   final TraceAlertEntity alert;

//   final VoidCallback onOpen;
//   final VoidCallback onWhy;

//   final Future<void> Function() onMarkReviewed;

//   /// For QC_FAILED quick actions
//   final Future<void> Function()? onApprove;
//   final NoteCallback? onHold;
//   final NoteCallback? onReject;

//   const TraceAlertCard({
//     super.key,
//     required this.alert,
//     required this.onOpen,
//     required this.onWhy,
//     required this.onMarkReviewed,
//     required this.onApprove,
//     required this.onHold,
//     required this.onReject,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;

//     final type = alert.alertType.trim().toUpperCase();
//     final reviewed = alert.isReviewed;

//     final updatedText = TraceFallbacks.formatTimeAgo(alert.updatedAt);

//     final bg = reviewed
//         ? scheme.surfaceContainerHighest.withOpacity(0.22)
//         : scheme.surface;
//     final borderColor = reviewed
//         ? scheme.outline.withOpacity(0.12)
//         : scheme.outline.withOpacity(0.20);
//     final opacity = reviewed ? 0.62 : 1.0;

//     return Opacity(
//       opacity: opacity,
//       child: Container(
//         decoration: BoxDecoration(
//           color: bg,
//           borderRadius: BorderRadius.circular(AppRadius.lg),
//           border: Border.all(color: borderColor),
//           boxShadow: reviewed
//               ? const []
//               : const [
//                   BoxShadow(
//                     blurRadius: 10,
//                     offset: Offset(0, 5),
//                     color: Color(0x0F000000),
//                   ),
//                 ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header row
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _typeIcon(context, type),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Wrap(
//                           crossAxisAlignment: WrapCrossAlignment.center,
//                           spacing: 8,
//                           runSpacing: 6,
//                           children: [
//                             Text(
//                               "${alert.product} • ${alert.batchId}",
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: Theme.of(
//                                 context,
//                               ).textTheme.titleMedium?.bold,
//                             ),
//                             if (reviewed)
//                               _pill(
//                                 context,
//                                 label: 'Reviewed ✅',
//                                 color: Colors.grey,
//                                 outlined: true,
//                               ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "Line: ${alert.line}  •  Qty: ${alert.quantity}",
//                           style: Theme.of(context).textTheme.bodySmall
//                               ?.copyWith(
//                                 fontWeight: FontWeight.w700,
//                                 color: scheme.onSurface.withOpacity(0.70),
//                               ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   _pill(
//                     context,
//                     label: alert.riskLabel,
//                     color: _riskColor(alert.riskLabel),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 10),

//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: [
//                   _pill(
//                     context,
//                     label: _statusLabel(alert.status),
//                     color: _statusColor(scheme, alert.status),
//                   ),
//                   _pill(
//                     context,
//                     label: "Risk ${alert.riskScore}",
//                     color: scheme.outline,
//                     outlined: true,
//                   ),
//                   _pill(
//                     context,
//                     label: "Updated $updatedText",
//                     color: scheme.outline,
//                     outlined: true,
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 10),

//               Text(
//                 alert.message,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
//               ),

//               const SizedBox(height: 10),

//               // Actions row (Wrap to avoid overflow)
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: [
//                     OutlinedButton.icon(
//                       onPressed: onWhy,
//                       icon: const Icon(Icons.help_outline_rounded, size: 18),
//                       label: const Text("Why?"),
//                     ),

//                     // Quick actions by type
//                     if (type == 'QC_FAILED' && !reviewed) ...[
//                       OutlinedButton(
//                         onPressed: onApprove,
//                         child: const Text("Approve"),
//                       ),
//                       OutlinedButton(
//                         onPressed: () async {
//                           final note = await _noteDialog(
//                             context,
//                             title: "Hold note (required)",
//                           );
//                           if (note == null) return;
//                           await onHold?.call(note);
//                         },
//                         child: const Text("Hold"),
//                       ),
//                       OutlinedButton(
//                         onPressed: () async {
//                           final note = await _noteDialog(
//                             context,
//                             title: "Reject note (required)",
//                           );
//                           if (note == null) return;
//                           await onReject?.call(note);
//                         },
//                         child: const Text("Reject"),
//                       ),
//                     ] else ...[
//                       OutlinedButton.icon(
//                         onPressed: reviewed
//                             ? null
//                             : () async => onMarkReviewed(),
//                         icon: const Icon(Icons.done_all_rounded, size: 18),
//                         label: const Text("Reviewed"),
//                       ),
//                     ],

//                     FilledButton.icon(
//                       onPressed: onOpen,
//                       icon: const Icon(Icons.open_in_new_rounded, size: 18),
//                       label: const Text("Open"),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<String?> _noteDialog(
//     BuildContext context, {
//     required String title,
//   }) async {
//     final ctrl = TextEditingController();
//     String? error;

//     final result = await showDialog<String>(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) {
//         return StatefulBuilder(
//           builder: (_, setState) {
//             return AlertDialog(
//               title: Text(title),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: ctrl,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                       hintText: "Write a short note...",
//                       errorText: error,
//                     ),
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(dialogContext).pop(null),
//                   child: const Text("Cancel"),
//                 ),
//                 FilledButton(
//                   onPressed: () async {
//                     final note = ctrl.text.trim();
//                     if (note.isEmpty) {
//                       setState(() => error = "Note is required.");
//                       return;
//                     }
//                     FocusScope.of(dialogContext).unfocus();
//                     await Future.delayed(const Duration(milliseconds: 20));
//                     Navigator.of(dialogContext).pop(note);
//                   },
//                   child: const Text("Confirm"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );

//     ctrl.dispose();
//     return result;
//   }

//   Widget _typeIcon(BuildContext context, String type) {
//     final scheme = Theme.of(context).colorScheme;
//     IconData icon = Icons.notifications_rounded;
//     Color color = scheme.outline;

//     switch (type) {
//       case 'QC_FAILED':
//         icon = Icons.error_rounded;
//         color = scheme.error;
//         break;
//       case 'EVIDENCE_MISSING':
//         icon = Icons.warning_rounded;
//         color = scheme.tertiary;
//         break;
//       case 'SLA_CRITICAL':
//         icon = Icons.timer_off_rounded;
//         color = scheme.error.withOpacity(0.85);
//         break;
//       case 'SLA_WARNING':
//         icon = Icons.timer_rounded;
//         color = scheme.tertiary.withOpacity(0.85);
//         break;
//       case 'READY':
//         icon = Icons.local_shipping_rounded;
//         color = Colors.green;
//         break;
//     }

//     return Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Icon(icon, color: color),
//     );
//   }

//   Widget _pill(
//     BuildContext context, {
//     required String label,
//     required Color color,
//     bool outlined = false,
//   }) {
//     final scheme = Theme.of(context).colorScheme;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//       decoration: BoxDecoration(
//         color: outlined ? scheme.surface : color.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(999),
//         border: Border.all(
//           color: outlined
//               ? scheme.outline.withOpacity(0.18)
//               : color.withOpacity(0.25),
//         ),
//       ),
//       child: Text(
//         label,
//         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//           fontWeight: FontWeight.w900,
//           color: outlined ? scheme.onSurface.withOpacity(0.8) : color,
//         ),
//       ),
//     );
//   }

//   String _statusLabel(String status) {
//     final s = status.trim().toLowerCase();
//     if (s == 'failed') return 'FAILED';
//     if (s == 'waiting_qc') return 'WAITING QC';
//     if (s == 'passed') return 'PASSED';
//     if (s == 'in_progress') return 'IN PROGRESS';
//     return status.toUpperCase();
//   }

//   Color _statusColor(ColorScheme scheme, String status) {
//     final s = status.trim().toLowerCase();
//     if (s == 'failed') return scheme.error;
//     if (s == 'waiting_qc') return scheme.tertiary;
//     if (s == 'passed') return Colors.green;
//     return scheme.outline;
//   }

//   Color _riskColor(String label) {
//     final l = label.trim().toUpperCase();
//     if (l == 'HIGH') return Colors.red;
//     if (l == 'MEDIUM') return Colors.orange;
//     return Colors.green;
//   }
// }
