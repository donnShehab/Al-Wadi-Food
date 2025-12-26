import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_state.dart';

import 'qc_analytics_view_body.dart';
import '../qc_dashboard/qc_dashboard_skeleton.dart';

class QCAnalyticsViewBodyBlocConsumer extends StatelessWidget {
  const QCAnalyticsViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QCCubit, QCState>(
      builder: (context, state) {
        if (state is QCLoading) {
          return const QCDashboardSkeleton();
        }

        if (state is QCError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        /// ✅ إذا عندنا dashboard data نستخدمه
        if (state is QCDashboardLoaded) {
          return QCAnalyticsViewBody(
            trend: state.trend,

            results: state.allResults,
          );
        }

        /// ✅ fallback
        return const SizedBox();
      },
    );
  }
}
