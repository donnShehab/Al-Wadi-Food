import 'package:alwadi_food/manager_production/manager_production_today_satate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/presentation/auth/data/services/manager_dashboard_firestore_ds.dart';

class ManagerProductionTodayCubit extends Cubit<ManagerProductionTodayState> {
  final ManagerDashboardFirestoreDataSource ds;

  ManagerProductionTodayCubit(this.ds) : super(ManagerProductionTodayInitial());

  Future<void> load() async {
    try {
      emit(ManagerProductionTodayLoading());
      final items = await ds.fetchProductionTodayList();
      emit(ManagerProductionTodayLoaded(items));
    } catch (e) {
      emit(ManagerProductionTodayError("Failed to load Production Today"));
    }
  }
}
