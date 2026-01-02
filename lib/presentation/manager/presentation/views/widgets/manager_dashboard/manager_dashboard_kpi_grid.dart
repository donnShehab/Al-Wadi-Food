import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/manager_dashboard_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'manager_kpi_card.dart';

class ManagerDashboardKpiGrid extends StatelessWidget {
  final ManagerDashboardEntity data;

  const ManagerDashboardKpiGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final gridItems = [
      ManagerKpiCard(
        title: "Production Today",
        value: "${data.productionToday}",
        subtitle: "Batches",
        icon: Icons.factory_rounded,
        color: Colors.blue,
        onTap: () => context.push(AppRouter.KManagerProductionTodayView),
      ),
      ManagerKpiCard(
        title: "QC Inspections",
        value: "${data.qcInspectionsToday}",
        subtitle: "Inspections",
        icon: Icons.fact_check_rounded,
        color: Colors.purple,
        onTap: () => context.push(AppRouter.KManagerInspectionsTodayView),
      ),
      ManagerKpiCard(
        title: "Pending QC",
        value: "${data.pendingQC}",
        subtitle: "Waiting",
        icon: Icons.hourglass_bottom_rounded,
        color: Colors.orange,
        onTap: () => context.push(AppRouter.KqCPendingListView),
      ),
      ManagerKpiCard(
        title: "Pass Rate",
        value: "${data.passRate.toStringAsFixed(1)}%",
        subtitle: "Today",
        icon: Icons.check_circle_rounded,
        color: Colors.green,
        onTap: () => context.push(AppRouter.KManagerInspectionsTodayView),
      ),
    ];

    return Column(
      children: [
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: gridItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 135,
          ),
          itemBuilder: (context, index) => gridItems[index],
        ),
        const SizedBox(height: 14),

        /// ✅ Full width High Risk Card
        ManagerKpiCard(
          title: "High Risk Alerts",
          value: "${data.highRiskAlerts}",
          subtitle: data.highRiskAlerts > 0 ? "Critical" : "No Alerts",
          icon: Icons.warning_amber_rounded,
          color: Colors.red,
          fullWidth: true,
          onTap: () => context.push(AppRouter.KManagerHighRiskAlertsView),
        ),
      ],
    );
  }
}
