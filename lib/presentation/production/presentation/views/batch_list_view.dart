import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_list_view_body_bloc_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BatchListView extends StatelessWidget {
  const BatchListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductionCubit>()..loadAllBatches(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Production Batches')),
        body: const BatchListViewBodyBlocBuilder(),
      ),
    );
  }
}
