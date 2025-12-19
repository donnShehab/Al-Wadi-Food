// import 'package:alwadi_food/core/constants/app_constants.dart';
// import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
// import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
// import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
// import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
// import 'package:alwadi_food/presentation/widgets/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class BatchActions extends StatelessWidget {
//   final ProductionBatchEntity batch;
//   final String batchId;

//   const BatchActions({super.key, required this.batch, required this.batchId});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, state) {
//         if (state is! AuthSuccess) {
//           return const SizedBox();
//         }

//         final role = state.user.role;
//         final isSupervisor = role == AppConstants.roleSupervisor;
//         final isQC = role == AppConstants.roleQC;

//         return Column(
//           children: [
//             /// 🔴 Close Batch (Supervisor فقط)
//             if (isSupervisor &&
//                 batch.status == AppConstants.statusInProgress) ...[
//               CustomButton(
//                 text: "Close Batch",
//                 backgroundColor: theme.colorScheme.error,
//                 icon: Icons.stop_circle,
//                 onPressed: () {
//                   context.read<ProductionCubit>().closeBatch(batch);
//                 },
//               ),
//               const SizedBox(height: 12),
//             ],

//             /// 🟠 Send to QC (Supervisor فقط – بعد الإغلاق)
//             if (isSupervisor &&
//                 batch.status == AppConstants.statusInProgress) ...[
//               CustomButton(
//                 text: "Send to QC",
//                 backgroundColor: theme.colorScheme.secondary,
//                 icon: Icons.send,
//                 onPressed: () =>
//                     context.read<ProductionCubit>().sendToQC(batchId),
//               ),
//               const SizedBox(height: 12),
//             ],

//             /// 🧪 Start QC Inspection (QC فقط)
//             if (isQC && batch.status == AppConstants.statusWaitingQC) ...[
//               CustomButton(
//                 text: "Start QC Inspection",
//                 backgroundColor: Colors.green,
//                 icon: Icons.fact_check,
//                 onPressed: () {
//                   context.push('/qc-inspection/$batchId');
//                 },
//               ),
//               const SizedBox(height: 12),
//             ],

//             /// 🟢 View QC History (مسموح للجميع)
//             CustomButton(
//               text: "View QC History",
//               isOutlined: true,
//               icon: Icons.history,
//               onPressed: () => context.push('/qc-history/$batchId'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BatchActions extends StatelessWidget {
  final ProductionBatchEntity batch;
  final String batchId;

  const BatchActions({super.key, required this.batch, required this.batchId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is! AuthSuccess) return const SizedBox();

        final role = state.user.role;
        final isSupervisor = role == AppConstants.roleSupervisor;
        final isQC = role == AppConstants.roleQC;

        return Column(
          children: [
            /// 🔴 Supervisor – Close Batch
            if (isSupervisor &&
                batch.status == AppConstants.statusInProgress) ...[
              CustomButton(
                text: "Close Batch",
                icon: Icons.stop_circle,
                backgroundColor: theme.colorScheme.error,
                onPressed: () {
                  context.read<ProductionCubit>().closeBatch(batch);
                },
              ),
              const SizedBox(height: 12),
            ],

            /// 🟠 Supervisor – Send to QC
            if (isSupervisor &&
                batch.status == AppConstants.statusWaitingQC) ...[
              CustomButton(
                text: "Send to QC",
                icon: Icons.send,
                backgroundColor: theme.colorScheme.secondary,
                onPressed: () {
                  context.read<ProductionCubit>().sendToQC(batchId);
                },
              ),
              const SizedBox(height: 12),
            ],

            /// 🟢 QC – Start Inspection
            if (isQC && batch.status == AppConstants.statusWaitingQC) ...[
              CustomButton(
                text: "Start QC Inspection",
                icon: Icons.fact_check,
                backgroundColor: theme.colorScheme.primary,
                onPressed: () {
                  context.push('/qc-inspection/$batchId');
                },
              ),
              const SizedBox(height: 12),
            ],

            /// 🔵 View QC History (للجميع)
            CustomButton(
              text: "View QC History",
              isOutlined: true,
              icon: Icons.history,
              onPressed: () {
                context.push('/qc-history/$batchId');
              },
            ),
          ],
        );
      },
    );
  }
}
