import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/cubit/production_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'batch_list_view_body.dart';

class BatchListViewBodyBlocBuilder extends StatelessWidget {
  const BatchListViewBodyBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<ProductionCubit, ProductionState>(
    //   builder: (context, state) {
    //     if (state is ProductionLoading) {
    //       return const Center(child: CircularProgressIndicator());
    //     } else if (state is ProductionBatchesLoaded) {
    //       return BatchListViewBody(batches: state.batches);
    //     } else if (state is ProductionError) {
    //       return Center(child: Text(state.message));
    //     }
    //     return const SizedBox();
    //   },
    // );
    return BlocBuilder<ProductionCubit, ProductionState>(
      builder: (context, state) {
        Widget _buildState(ProductionState state) {
          if (state is ProductionLoading) {
            return const Center(
              key: ValueKey('loading'),
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProductionBatchesLoaded) {
            return BatchListViewBody(
              key: const ValueKey('loaded'),
              batches: state.batches,
            );
          }

          if (state is ProductionError) {
            return Center(
              key: const ValueKey('error'),
              child: Text(state.message),
            );
          }

          return const SizedBox(key: ValueKey('empty'));
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          },
          child: _buildState(state),
        );
      },
    );
  }
}
