import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_state.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_history/qc_history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class QCHistoryList extends StatelessWidget {
  const QCHistoryList({super.key});

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
          if (state.results.isEmpty) {
            return const Center(child: Text('No QC history yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              return QCHistoryItem(result: state.results[index]);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
