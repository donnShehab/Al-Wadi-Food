import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_state.dart';
import '../qc_dashboard/qc_dashboard_skeleton.dart';
import 'qc_insights_view_body.dart';

class QCInsightsViewBodyBlocConsumer extends StatelessWidget {
  const QCInsightsViewBodyBlocConsumer({super.key});

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

        if (state is QCDashboardLoaded) {
          return QCInsightsViewBody(
            allBatches:state.allBatches ,
            riskLevel: state.riskLevel,
            alerts: state.alerts,
            recommendations: state.recommendations,
          );
        }

        return const SizedBox();
      },
    );
  }
}
