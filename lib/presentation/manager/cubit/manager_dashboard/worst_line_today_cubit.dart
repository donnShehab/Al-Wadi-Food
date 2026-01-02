import 'package:alwadi_food/presentation/auth/data/services/manager_kpi_list_firestore_ds.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'worst_line_today_state.dart';

class WorstLineTodayCubit extends Cubit<WorstLineTodayState> {
  final ManagerKpiListFirestoreDataSource ds;

  WorstLineTodayCubit(this.ds) : super(WorstLineTodayInitial());

  Future<void> loadWorstLineFailedInspections(String lineName) async {
    emit(WorstLineTodayLoading());
    try {
      final items = await ds.fetchFailedInspectionsByLineToday(lineName);
      emit(WorstLineTodayLoaded(items));
    } catch (e) {
      emit(WorstLineTodayError("Failed to load worst line inspections"));
    }
  }
}
