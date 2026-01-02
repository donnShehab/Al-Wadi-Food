import 'package:alwadi_food/presentation/auth/data/services/manager_dashboard_firestore_ds.dart';
import 'package:alwadi_food/presentation/manager/domain/repo/manager_kpi_repo.dart';

class ManagerKpiRepoImpl implements ManagerKpiRepo {
  final ManagerDashboardFirestoreDataSource ds;

  ManagerKpiRepoImpl(this.ds);

  @override
  Future<List<Map<String, dynamic>>> getTodayBatches() {
    return ds.fetchTodayBatches();
  }

  @override
  Future<List<Map<String, dynamic>>> getTodayInspections() {
    return ds.fetchTodayInspections();
  }

  @override
  Future<List<Map<String, dynamic>>> getHighRiskAlertsToday() {
    return ds.fetchHighRiskAlertsToday();
  }
}
