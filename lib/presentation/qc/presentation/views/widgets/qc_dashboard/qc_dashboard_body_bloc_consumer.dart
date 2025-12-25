import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_state.dart';
import 'qc_dashboard_skeleton.dart';
import 'qc_dashboard_body.dart';

class QCDashboardBodyConsumer extends StatelessWidget {
  const QCDashboardBodyConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QCCubit, QCState>(
      listener: (context, state) {
        if (state is QCSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          
        }
      },
      builder: (context, state) {
        if (state is QCLoading) {
          return const QCDashboardSkeleton();
        }

        if (state is QCError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (state is QCDashboardLoaded) {
          return QCDashboardBody(
            pendingCount: state.pendingCount,
            passedToday: state.passedToday,
            failedToday: state.failedToday,
            recentResults: state.recentResults,
          );
        }

        return const SizedBox();
      },
    );
  }
}
