// import 'package:alwadi_food/core/constants/app_constants.dart';
// import 'package:alwadi_food/core/router/app_router.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:alwadi_food/theme.dart';

// class QCPendingBatchCard extends StatelessWidget {
//   final dynamic batch; // استبدل dynamic بالنوع الصحيح إذا كان لديك BatchEntity

//   const QCPendingBatchCard({super.key, required this.batch});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: AppSpacing.md),
//       child: ListTile(
//         leading: Icon(
//           Icons.assignment,
//           color: Theme.of(context).colorScheme.tertiary,
//         ),
//         title: Text(batch.product),
//         subtitle: Text('${batch.quantity} units • ${batch.line}'),
//         trailing: 
        
//         const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: () {
//           if (batch.status != AppConstants.statusWaitingQC) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('This batch is not ready for QC inspection'),
//               ),
//             );
//             return;
//           }

//           context.push('${AppRouter.KQCInspectionView}/${batch.batchId}');
//         },
//       ),
//     );
//   }
// }
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alwadi_food/theme.dart';

class QCPendingBatchCard extends StatelessWidget {
  final dynamic batch; // لاحقًا نستبدلها بـ ProductionBatchEntity

  const QCPendingBatchCard({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: Icon(Icons.assignment, color: theme.colorScheme.tertiary),
        title: Text(batch.product),
        subtitle: Text('${batch.quantity} units • ${batch.line}'),

        /// 👈 تحذير + سهم
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (batch.status == AppConstants.statusFailed)
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 20,
              ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),

        onTap: () {
          /// ❌ حماية: لا Inspection إلا إذا Waiting QC
          if (batch.status != AppConstants.statusWaitingQC) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This batch is not ready for QC inspection'),
              ),
            );
            return;
          }

          context.push('${AppRouter.KQCInspectionView}/${batch.batchId}');
        },
      ),
    );
  }
}
