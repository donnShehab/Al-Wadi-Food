import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'qc_history_body.dart';

class QCHistoryBodyBlocBuilder extends StatelessWidget {
  const QCHistoryBodyBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QCCubit, QCState>(
      builder: (context, state) {
        if (state is QCLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is QCResultsLoaded) {
          return QCHistoryBody(results: state.results);
        } else if (state is QCError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }
}

