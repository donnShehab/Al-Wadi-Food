import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/cubit/production_state.dart';
import 'batch_details_body.dart';
import 'package:go_router/go_router.dart';

class BatchDetailsBodyBlocConsumer extends StatelessWidget {
  final String batchId;

  const BatchDetailsBodyBlocConsumer({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductionCubit, ProductionState>(
      listener: (context, state) {
        if (state is ProductionSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          context.pop();
        }
      },
      builder: (context, state) {
        return  BatchDetailsBody(state: state, batchId: batchId);
      },
    );
  }
}
