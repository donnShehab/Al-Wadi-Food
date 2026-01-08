import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/cubit/production_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manager_batch_details_body.dart';

class ManagerBatchDetailsBodyBlocConsumer extends StatelessWidget {
  final String batchId;

  const ManagerBatchDetailsBodyBlocConsumer({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductionCubit, ProductionState>(
      builder: (context, state) {
        return ManagerBatchDetailsBody(state: state, batchId: batchId);
      },
    );
  }
}
