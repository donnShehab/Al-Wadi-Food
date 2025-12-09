import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details_body_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/core/di/injection.dart';

class BatchDetailsView extends StatelessWidget {
  final String batchId;

  const BatchDetailsView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductionCubit>()..loadBatchById(batchId),
      child: BatchDetailsBodyBlocConsumer(batchId: batchId),
    );
  }
}
