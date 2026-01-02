import 'package:alwadi_food/presentation/auth/data/services/manager_dashboard_firestore_ds.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manager_action_needed_state.dart';

class ManagerActionNeededCubit extends Cubit<ManagerActionNeededState> {
  final ManagerDashboardFirestoreDataSource ds;

  ManagerActionNeededCubit(this.ds) : super(ManagerActionNeededInitial());

  Future<void> loadActionNeeded() async {
    emit(ManagerActionNeededLoading());
    try {
      final highRisk = await ds.fetchHighRiskAlertsToday();
      final pending = await ds.fetchPendingBatches();
      final failed = await ds.fetchFailedInspectionsToday();

      emit(
        ManagerActionNeededLoaded(
          highRiskAlerts: highRisk,
          pendingBatches: pending,
          failedInspections: failed,
        ),
      );
    } catch (e) {
      emit(ManagerActionNeededError("Failed to load action center"));
    }
  }

  Future<void> resolveAlert(String inspectionId, String managerId) async {
    await ds.markAlertResolved(
      inspectionId: inspectionId,
      managerId: managerId,
    );
    await loadActionNeeded();
  }

  Future<void> assignQc(String inspectionId, String qcId, String qcName) async {
    await ds.assignQcToAlert(
      inspectionId: inspectionId,
      qcId: qcId,
      qcName: qcName,
    );
    await loadActionNeeded();
  }
}
