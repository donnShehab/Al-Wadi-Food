import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_batch_form.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/cubit/production_state.dart';
import 'package:alwadi_food/presentation/widgets/loading_overlay.dart';
import 'package:go_router/go_router.dart';

class CreateBatchViewBodyBlocConsumer extends StatelessWidget {
  const CreateBatchViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<ProductionCubit, ProductionState>(
      listener: (context, state) {
        if (state is ProductionSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          context.pop();
        } else if (state is ProductionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is ProductionLoading,
          child: const CreateBatchForm(),
        );
      },
    );
  }
}
