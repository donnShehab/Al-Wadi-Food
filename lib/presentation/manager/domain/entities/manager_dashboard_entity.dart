import 'package:alwadi_food/presentation/manager/domain/entities/manager_trend_day_entity.dart';

class ManagerDashboardEntity {
  final String managerName;
  final String managerRole;
  final DateTime today;

  final int productionToday;
  final int unitsToday;
  final int qcInspectionsToday;
  final int pendingQC;

  final double passRate;
  final int highRiskAlerts;

  final String worstLineToday;
  final String bestLineToday;
  final String mostRepeatedFailure;
  final String bestInspector;

  final List<ManagerTrendDayEntity> trend;

  ManagerDashboardEntity({
    required this.managerName,
    required this.managerRole,
    required this.today,
    required this.productionToday,
    required this.unitsToday,
    required this.qcInspectionsToday,
    required this.pendingQC,
    required this.passRate,
    required this.highRiskAlerts,
    required this.worstLineToday,
    required this.bestLineToday,
    required this.mostRepeatedFailure,
    required this.bestInspector,
    required this.trend,
  });
}
