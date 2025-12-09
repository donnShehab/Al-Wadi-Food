import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_history_body_bloc_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/di/injection.dart';

class QCHistoryView extends StatelessWidget {
  final String batchId;

  const QCHistoryView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QCCubit>()..loadQCResultsByBatchId(batchId),
      child:  Scaffold(
      appBar: AppBar(title: Text('QC History')),
        body: QCHistoryBodyBlocBuilder(),
      ),
    );
  }
}

// class _QCHistoryAppBar extends StatelessWidget with PreferredSizeWidget {
//   const _QCHistoryAppBar();

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(title: const Text('QC History'));
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
