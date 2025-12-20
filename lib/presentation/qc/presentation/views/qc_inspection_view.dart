import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_state.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_inspection_body_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/di/injection.dart';

// class QCInspectionView extends StatelessWidget {
//   final String batchId;

//   const QCInspectionView({super.key, required this.batchId});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => getIt<QCCubit>()..loadQCResultsByBatchId(batchId),
//       child: Scaffold(
//         appBar: AppBar(title: const Text('QC Inspection')),
//         body: BlocBuilder<QCCubit, QCState>(
//           builder: (context, state) {
//             if (state is QCResultsLoaded && state.results.isNotEmpty) {
//               return const Center(
//                 child: Text(
//                   'This batch has already been inspected',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               );
//             }

//             return QCInspectionBodyBlocConsumer(batchId: batchId);
//           },
//         ),
//       ),
//     );
//   }
// }
class QCInspectionView extends StatelessWidget {
  final String batchId;

  const QCInspectionView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QCCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('QC Inspection')),
        body: QCInspectionBodyBlocConsumer(batchId: batchId),
      ),
    );
  }
}
