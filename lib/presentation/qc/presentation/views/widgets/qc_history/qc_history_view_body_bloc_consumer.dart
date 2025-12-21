import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_state.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_history/qc_history_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QCHistoryViewBodyBlocConsumer extends StatelessWidget {
  final String batchId;

  const QCHistoryViewBodyBlocConsumer({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QCCubit>(
      create: (_) => getIt<QCCubit>()..loadQCResultsByBatchId(batchId),
      child: BlocBuilder<QCCubit, QCState>(
        builder: (context, state) {
          if (state is QCLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QCError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          if (state is QCResultsLoaded) {
            return QCHistoryViewBody(results: state.results);
          }

          return const SizedBox();
        },
      ),
    );
  }
}
