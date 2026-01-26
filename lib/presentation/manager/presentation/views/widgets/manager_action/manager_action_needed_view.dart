import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manager_action_needed_view_body.dart';

class ManagerActionNeededView extends StatelessWidget {
  const ManagerActionNeededView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // تأكد أن getIt يوفر الـ Cubit مع الـ DataSource
      create: (_) => getIt<ManagerActionNeededCubit>()..loadActionNeeded(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text(
            "Action Center",
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () =>
                    context.read<ManagerActionNeededCubit>().loadActionNeeded(),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ManagerActionNeededCubit, ManagerActionNeededState>(
          builder: (context, state) {
            DateTime? lastUpdated;
            if (state is ManagerActionNeededLoaded) {
              lastUpdated = state.lastUpdated;
            }

            return ManagerActionNeededViewBody(
              // lastUpdated: lastUpdated,
              // onRefreshTap: () =>
              //     context.read<ManagerActionNeededCubit>().loadActionNeeded(),
            );
          },
        ),
      ),
    );
  }
}
