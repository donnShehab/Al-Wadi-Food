import 'package:alwadi_food/presentation/manager/cubit/dashboard_cubit.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/dashboard_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardCubit>()..loadDashboardData(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: DashboardViewBodyBlocConsumer(),
      ),
    );
  }
}
