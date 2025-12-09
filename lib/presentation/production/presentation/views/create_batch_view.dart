import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/core/di/injection.dart';

class CreateBatchView extends StatelessWidget {
  const CreateBatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductionCubit>(),
      child: const CreateBatchViewBodyBlocConsumer(),
    );
  }
}
