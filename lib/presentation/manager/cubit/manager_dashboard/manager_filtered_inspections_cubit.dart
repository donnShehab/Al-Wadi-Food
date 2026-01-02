import 'package:alwadi_food/presentation/auth/data/services/manager_kpi_list_firestore_ds.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manager_filtered_inspections_state.dart';

class ManagerFilteredInspectionsCubit
    extends Cubit<ManagerFilteredInspectionsState> {
  final ManagerKpiListFirestoreDataSource ds;

  ManagerFilteredInspectionsCubit(this.ds)
    : super(ManagerFilteredInspectionsInitial());

  Future<void> loadFiltered({
    required String filterType,
    required String filterValue,
  }) async {
    emit(ManagerFilteredInspectionsLoading());

    try {
      final inspections = await ds.fetchTodayInspectionsWithBatchInfo();

      final filtered = inspections.where((i) {
        final value = (i[filterType] ?? "").toString();
        return value.trim().toLowerCase() == filterValue.trim().toLowerCase();
      }).toList();

      emit(ManagerFilteredInspectionsLoaded(filtered));
    } catch (e) {
      emit(
        ManagerFilteredInspectionsError("Failed to load filtered inspections"),
      );
    }
  }
}
