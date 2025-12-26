import 'package:alwadi_food/presentation/qc/presentation/views/qc_analytics_view.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/qc_insights_view.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/qc_reports_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_state.dart';

import 'widgets/qc_dashboard/qc_dashboard_body.dart'; // Overview

class QCCommandCenterView extends StatefulWidget {
  const QCCommandCenterView({super.key});

  @override
  State<QCCommandCenterView> createState() => _QCCommandCenterViewState();
}

class _QCCommandCenterViewState extends State<QCCommandCenterView> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    context.read<QCCubit>().loadQCDashboard(); // ✅ تحميل مباشر
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      /// ✅ AppBar بسيط + فخم
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        title: const Text(
          "QC Command Center",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),

      /// ✅ Body
      body: BlocBuilder<QCCubit, QCState>(
        builder: (context, state) {
          if (state is QCLoading) {
            return const Center(child: CircularProgressIndicator());
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
            final pages = [
              /// ✅ Overview
              QCDashboardBody(
                pendingCount: state.pendingCount,
                passedToday: state.passedToday,
                failedToday: state.failedToday,
                recentResults: state.recentResults,
                riskLevel: state.riskLevel,
                alerts: state.alerts,
                trend: state.trend,
                recommendations: state.recommendations,
              ),

              /// ✅ Analytics
              QCAnalyticsView(),

              //  ✅ Insights
              QCInsightsView(),

              // ✅ Reports (Placeholder)
              const QCReportsView(),
            ];

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: pages[_index],
            );
          }

          return const SizedBox();
        },
      ),

      /// ✅ Bottom Navigation
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        height: 68,
        backgroundColor: Colors.white,
        indicatorColor: theme.colorScheme.primary.withOpacity(0.12),
        onDestinationSelected: (value) {
          setState(() => _index = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: "Overview",
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined),
            selectedIcon: Icon(Icons.show_chart),
            label: "Analytics",
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb),
            label: "Insights",
          ),
          NavigationDestination(
            icon: Icon(Icons.picture_as_pdf_outlined),
            selectedIcon: Icon(Icons.picture_as_pdf),
            label: "Reports",
          ),
        ],
      ),
    );
  }
}
