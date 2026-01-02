import 'package:flutter_bloc/flutter_bloc.dart';
import 'manager_kpi_list_state.dart';
import 'package:alwadi_food/presentation/auth/data/services/manager_kpi_list_firestore_ds.dart';

class ManagerKpiListCubit extends Cubit<ManagerKpiListState> {
  final ManagerKpiListFirestoreDataSource ds;

  ManagerKpiListCubit(this.ds) : super(ManagerKpiListInitial());

  Future<void> loadTodayBatches() async {
    emit(ManagerKpiListLoading());
    try {
      final items = await ds.fetchTodayBatches();
      emit(ManagerKpiListLoaded(items));
    } catch (_) {
      emit(ManagerKpiListError("Failed to load batches"));
    }
  }

  Future<void> loadTodayInspections() async {
    emit(ManagerKpiListLoading());
    try {
      final items = await ds.fetchTodayInspectionsWithBatchInfo();
      emit(ManagerKpiListLoaded(items));
    } catch (_) {
      emit(ManagerKpiListError("Failed to load inspections"));
    }
  }

  Future<void> loadHighRiskAlerts() async {
    emit(ManagerKpiListLoading());
    try {
      final items = await ds.fetchHighRiskAlertsWithBatchInfo();
      emit(ManagerKpiListLoaded(items));
    } catch (_) {
      emit(ManagerKpiListError("Failed to load alerts"));
    }
  }
}
