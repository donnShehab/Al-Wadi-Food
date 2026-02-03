import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_list_view_body_bloc_builder.dart';
import 'package:alwadi_food/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BatchListView extends StatelessWidget {
  const BatchListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => getIt<ProductionCubit>()..listenToBatchesStream(),
      child: Scaffold(
        // ✅ UI-only: let body paint the executive background
        backgroundColor: theme.colorScheme.surface,
        appBar: buildAppBar(
          context,
          title: 'Production Batches',
          backgroundColor: theme.colorScheme.primary,
          titleColor: Colors.white,
          showBackButton: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              color: Colors.white,
              onPressed: () {
                // (كما هو) ممكن لاحقاً تضيف فلترة حقيقية
              },
            ),
          ],
        ),
        body: const BatchListViewBodyBlocBuilder(),
      ),
    );
  }
}
