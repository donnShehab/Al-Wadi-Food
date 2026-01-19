// import 'package:alwadi_food/presentation/manager/presentation/views/widgets/reports/reports_center_firestore_ds.dart';
// import 'package:flutter/material.dart';

// class ReportsFilterSelector extends StatelessWidget {
//   final ReportsRange selected;
//   final Function(ReportsRange) onChanged;

//   const ReportsFilterSelector({
//     super.key,
//     required this.selected,
//     required this.onChanged,
//   });

//   String _label(ReportsRange r) {
//     switch (r) {
//       case ReportsRange.today:
//         return "Today";
//       case ReportsRange.week:
//         return "Last 7 Days";
//       case ReportsRange.month:
//         return "Last Month";
//     }
//   }

//   IconData _icon(ReportsRange r) {
//     switch (r) {
//       case ReportsRange.today:
//         return Icons.today_rounded;
//       case ReportsRange.week:
//         return Icons.date_range_rounded;
//       case ReportsRange.month:
//         return Icons.calendar_month_rounded;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;

//     return Container(
//       padding: const EdgeInsets.all(6),
//       decoration: ShapeDecoration(
//         color: scheme.surfaceContainerHighest.withOpacity(0.35),
//         shape: const StadiumBorder(),
//         shadows: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.035),
//             blurRadius: 18,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Row(
//         children: ReportsRange.values.map((r) {
//           final isActive = r == selected;

//           return Expanded(
//             child: InkWell(
//               borderRadius: BorderRadius.circular(999),
//               onTap: () => onChanged(r),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 240),
//                 curve: Curves.easeOutCubic,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 decoration: ShapeDecoration(
//                   shape: const StadiumBorder(),
//                   color: isActive ? scheme.primary : Colors.transparent,
//                   shadows: isActive
//                       ? [
//                           BoxShadow(
//                             color: scheme.primary.withOpacity(0.22),
//                             blurRadius: 18,
//                             offset: const Offset(0, 10),
//                           ),
//                         ]
//                       : [],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       _icon(r),
//                       size: 18,
//                       color: isActive ? Colors.white : scheme.onSurface,
//                     ),
//                     const SizedBox(width: 7),
//                     Text(
//                       _label(r),
//                       style: TextStyle(
//                         fontWeight: isActive
//                             ? FontWeight.w900
//                             : FontWeight.w700,
//                         fontSize: 12,
//                         color: isActive ? Colors.white : scheme.onSurface,
//                         letterSpacing: 0.1,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/reports/reports_center_firestore_ds.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/manager/cubit/reports/reports_center_cubit.dart';

class ReportsFilterSelector extends StatelessWidget {
  final ReportsRange selected;
  final Function(ReportsRange) onChanged;

  const ReportsFilterSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Use your REAL enum:
    final ranges = ReportsRange.values;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: scheme.surfaceVariant.withOpacity(0.20),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: scheme.outline.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ranges.map((r) {
          final bool active = r == selected;

          return GestureDetector(
            onTap: () => onChanged(r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: scheme.primary.withOpacity(0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                r.name.toUpperCase(),
                style: TextStyle(
                  color: active
                      ? scheme.primary
                      : scheme.onSurface.withOpacity(0.65),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
