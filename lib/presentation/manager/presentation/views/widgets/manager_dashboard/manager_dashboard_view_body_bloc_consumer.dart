import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_dashboard/kpi_shimmer_grid.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_dashboard/manager_alert_preview_section.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_dashboard/manager_header_card.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_dashboard/manager_dashboard_kpi_grid.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_dashboard/manager_insights_section.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_dashboard/manager_trend_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_dashboard/manager_dashboard_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_dashboard/manager_dashboard_state.dart';
import 'package:alwadi_food/theme.dart';
import 'package:go_router/go_router.dart';

class ManagerDashboardViewBodyBlocConsumer extends StatelessWidget {
  final ThemeData theme;

  const ManagerDashboardViewBodyBlocConsumer({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<ManagerDashboardCubit, ManagerDashboardState>(
        listener: (context, state) {
          if (state is ManagerDashboardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
        if (state is ManagerDashboardLoading) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: KpiShimmerGrid(),
            );
          }


          if (state is ManagerDashboardLoaded) {
            final data = state.data;

            return SingleChildScrollView(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ✅ NEW Header Card (Professional)
               ManagerHeaderCard(
                    name: data.managerName,
                    role: data.managerRole,
                    date: data.today,
                    attentionNeeded: data.highRiskAlerts > 0,
                    passRate: data.passRate,
                    pendingQC: data.pendingQC,
                    alerts: data.highRiskAlerts,
                  ),


                  const SizedBox(height: 18),

                  /// ✅ KPI Cards Grid
                  ManagerDashboardKpiGrid(data: data),

                  const SizedBox(height: 20),

                  /// ✅ Smart Insights
                  ManagerInsightsSection(data: data),

                  const SizedBox(height: 20),
                  ManagerTrendSection(trend: data.trend),

                  const SizedBox(height: 20),


                  /// ✅ Alerts Preview
                  ManagerAlertPreviewSection(
highRiskAlerts: data.highRiskAlerts,
                        ),                 

                  const SizedBox(height: 80),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
