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
      print("❌ Action center error: $e");
      emit(ManagerActionNeededError("Failed to load action center: $e"));
    }
  }

  /// ✅ NEW: Fetch QC users list
  Future<List<Map<String, dynamic>>> fetchQcUsers() async {
    try {
      return await ds.fetchQcUsers();
    } catch (e) {
      print("❌ Fetch QC users failed: $e");
      return [];
    }
  }

  // ✅ Remove item locally instantly (UI)
  void removeHighRiskItem(String inspectionId) {
    if (state is! ManagerActionNeededLoaded) return;
    final current = state as ManagerActionNeededLoaded;

    final updated = current.highRiskAlerts
        .where((i) => (i["id"] ?? "").toString() != inspectionId)
        .toList();

    emit(
      ManagerActionNeededLoaded(
        highRiskAlerts: updated,
        pendingBatches: current.pendingBatches,
        failedInspections: current.failedInspections,
      ),
    );
  }
Future<bool> resolveAlert({
    required String inspectionId,
    required String managerId,
    required String managerName,
    String? note,
  }) async {
    try {
      await ds.markAlertResolved(
        inspectionId: inspectionId,
        managerId: managerId,
        managerName: managerName,
        note: note,
      );

      await loadActionNeeded();
      return true;
    } catch (e) {
      print("❌ Resolve failed: $e");
      return false;
    }
  }



  Future<bool> assignQc({
    required String inspectionId,
    required String qcId,
    required String qcName,
  }) async {
    try {
      await ds.assignQcToAlert(
        inspectionId: inspectionId,
        qcId: qcId,
        qcName: qcName,
      );
      await loadActionNeeded();
      return true;
    } catch (e) {
      print("❌ Assign QC failed: $e");
      return false;
    }
  }
}
