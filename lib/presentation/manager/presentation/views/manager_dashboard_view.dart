import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_dashboard/manager_dashboard_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_dashboard/manager_dashboard_cubit.dart';

class ManagerDashboardView extends StatelessWidget {
  const ManagerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ManagerDashboardCubit>()..loadDashboard(),
      child: const ManagerDashboardViewBody(),
    );
  }
}
