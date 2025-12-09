import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/cubit/production_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'batch_list_view_body.dart';

class BatchListViewBodyBlocBuilder extends StatelessWidget {
  const BatchListViewBodyBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductionCubit, ProductionState>(
      builder: (context, state) {
        if (state is ProductionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductionBatchesLoaded) {
          return BatchListViewBody(batches: state.batches);
        } else if (state is ProductionError ) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }
}
