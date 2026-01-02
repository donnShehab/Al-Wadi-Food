import 'package:alwadi_food/presentation/auth/data/services/manager_dashboard_firestore_ds.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/manager_dashboard_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/repo/manager_dashboard_repo.dart';

class ManagerDashboardRepoImpl implements ManagerDashboardRepo {
  final ManagerDashboardFirestoreDataSource ds;

  ManagerDashboardRepoImpl(this.ds);

  @override
  Future<ManagerDashboardEntity> getDashboardData() async {
    return await ds.fetchDashboard();
  }
}
