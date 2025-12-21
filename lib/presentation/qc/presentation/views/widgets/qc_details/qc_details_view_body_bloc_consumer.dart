import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_state.dart';
import 'qc_details_view_body.dart';

class QCDetailsViewBodyBlocConsumer extends StatelessWidget {
  final String inspectionId;

  const QCDetailsViewBodyBlocConsumer({super.key, required this.inspectionId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QCCubit, QCState>(
      builder: (context, state) {
        if (state is QCLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is QCError) {
          return Center(child: Text(state.message));
        }

        if (state is QCResultsLoaded) {
          final result = state.results.firstWhere(
            (r) => r.inspectionId == inspectionId,
          );

          return QCDetailsViewBody(result: result);
        }

        return const SizedBox();
      },
    );
  }
}
