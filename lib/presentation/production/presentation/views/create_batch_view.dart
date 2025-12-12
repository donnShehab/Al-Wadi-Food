
import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/create_batch_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBatchView extends StatelessWidget {
  const CreateBatchView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => getIt<ProductionCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        body: const CreateBatchViewBody(),
      ),
    );
  }
}
