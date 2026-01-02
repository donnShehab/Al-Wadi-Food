import '../entities/manager_dashboard_entity.dart';

abstract class ManagerDashboardRepo {
  Future<ManagerDashboardEntity> getDashboardData();
}
