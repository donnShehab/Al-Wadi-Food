import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/presentation/auth/data/services/manager_dashboard_firestore_ds.dart';

part 'manager_resolved_alerts_state.dart';

class ManagerResolvedAlertsCubit extends Cubit<ManagerResolvedAlertsState> {
  final ManagerDashboardFirestoreDataSource ds;

  ManagerResolvedAlertsCubit(this.ds) : super(ManagerResolvedAlertsInitial());

  Future<void> loadResolvedAlerts() async {
    emit(ManagerResolvedAlertsLoading());
    try {
      final resolved = await ds.fetchResolvedHighRiskAlerts();
      emit(ManagerResolvedAlertsLoaded(resolved));
    } catch (e) {
      emit(ManagerResolvedAlertsError("Failed to load resolved alerts: $e"));
    }
  }
}
