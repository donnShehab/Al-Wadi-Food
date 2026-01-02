import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_kpi_list/manager_kpi_list_cubit.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/kpi_list/manager_production_today_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagerProductionTodayView extends StatelessWidget {
  const ManagerProductionTodayView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ManagerKpiListCubit>()..loadTodayBatches(),
      child: const ManagerProductionTodayViewBody(),
    );
  }
}
