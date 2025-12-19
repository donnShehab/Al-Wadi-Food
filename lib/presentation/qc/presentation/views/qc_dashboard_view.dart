import 'package:alwadi_food/presentation/qc/cubit/qc_dashboard/qc_dashboard_cubit.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard_body_bloc_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/di/injection.dart';

class QCDashboardView extends StatelessWidget {
  const QCDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QCDashboardCubit>()..loadDashboard(),
      child: Scaffold(
        appBar: AppBar(title: const Text('QC Dashboard')),
        body: const QCDashboardBodyBlocBuilder(),
      ),
    );
  }
}
