import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/presentation/manager/domain/repo/manager_dashboard_repo.dart';
import 'manager_dashboard_state.dart';

class ManagerDashboardCubit extends Cubit<ManagerDashboardState> {
  final ManagerDashboardRepo repo;

  ManagerDashboardCubit(this.repo) : super(ManagerDashboardInitial());
Future<void> loadDashboard() async {
    emit(ManagerDashboardLoading());
    try {
      final data = await repo.getDashboardData();
      emit(ManagerDashboardLoaded(data));
    } catch (e) {
      debugPrint("🔥 ManagerDashboard Error: $e");
      emit(ManagerDashboardError("Failed to load manager dashboard"));
    }
  }

}
