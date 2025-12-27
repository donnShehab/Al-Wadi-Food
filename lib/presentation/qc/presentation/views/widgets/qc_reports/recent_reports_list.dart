// import 'package:alwadi_food/presentation/qc/domain/entites/qc_report_entity.dart';
// import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_reports/qc_report_tile.dart';
// import 'package:flutter/material.dart';

// class QCRecentReportsList extends StatelessWidget {
//   final List<QCReportEntity> reports;

//   const QCRecentReportsList({super.key, required this.reports});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     if (reports.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: theme.colorScheme.primary.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [
//             const Icon(Icons.info_outline, color: Colors.grey),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 "No reports generated yet.",
//                 style: theme.textTheme.bodyMedium,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return Column(
//       children: reports
//           .map((report) => QCRecentReportTile(report: report))
//           .toList(),
//     );
//   }
// }
