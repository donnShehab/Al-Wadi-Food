import 'package:alwadi_food/presentation/qc/cubit/qc_dashboard/qc_dashboard_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_dashboard/qc_dashboard_state.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QCDashboardBodyBlocBuilder extends StatelessWidget {
  const QCDashboardBodyBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QCDashboardCubit, QCDashboardState>(
      builder: (context, state) {
        if (state is QCDashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is QCDashboardError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is QCDashboardLoaded) {
          return QCDashboardBody(
            pendingCount: state.pendingCount,
            passedToday: state.passedToday,
            failedToday: state.failedToday,
          );
        }

        return const SizedBox();
      },
    );
  }
}
