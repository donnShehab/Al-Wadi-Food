import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_cubit.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_action/manager_action_needed_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagerActionNeededView extends StatelessWidget {
  const ManagerActionNeededView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ManagerActionNeededCubit>()..loadActionNeeded(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Action Needed"), centerTitle: true),
        body: const ManagerActionNeededViewBody(),
      ),
    );
  }
}
