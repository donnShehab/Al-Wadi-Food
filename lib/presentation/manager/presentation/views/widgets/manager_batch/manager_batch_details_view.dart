import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_batch/manager_batch_details_body_bloc_consumer.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagerBatchDetailsView extends StatelessWidget {
  final String batchId;

  const ManagerBatchDetailsView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductionCubit>()..loadBatchById(batchId),
      child: ManagerBatchDetailsBodyBlocConsumer(batchId: batchId),
    );
  }
}
