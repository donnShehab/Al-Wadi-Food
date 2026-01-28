import 'package:alwadi_food/presentation/auth/data/services/manager_dashboard_firestore_ds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manager_action_needed_state.dart';

// ✅ Use the new DataSource file (recommended)

class ManagerActionNeededCubit extends Cubit<ManagerActionNeededState> {
  final ManagerDashboardFirestoreDataSource ds;

  static final ValueNotifier<int> pendingCountNotifier = ValueNotifier<int>(0);

  ManagerActionNeededCubit(this.ds) : super(ManagerActionNeededInitial());

  Future<void> loadActionNeeded({int limit = 100}) async {
    emit(ManagerActionNeededLoading());
    try {
      final results = await Future.wait([
        ds.fetchPendingBatches(limit: limit),
        ds.fetchFailedInspectionsToday(limit: limit),
        ds.fetchApprovedBatches(limit: limit),
        ds.fetchBlockedBatches(limit: limit),
        ds.fetchHighRiskAlertsToday(limit: limit),
      ]);

      final loaded = ManagerActionNeededLoaded(
        lastUpdated: DateTime.now(),
        pendingBatches: results[0] as List<Map<String, dynamic>>,
        failedInspections: results[1] as List<Map<String, dynamic>>,
        approvedBatches: results[2] as List<Map<String, dynamic>>,
        blockedBatches: results[3] as List<Map<String, dynamic>>,
        highRiskAlerts: results[4] as List<Map<String, dynamic>>,
      );

      pendingCountNotifier.value = loaded.pendingCount;

      emit(loaded);
    } catch (e) {
      emit(ManagerActionNeededError(e.toString()));
    }
  }

  // ✅ Resolve Alert
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
    } catch (_) {
      return false;
    }
  }

  // ✅ Fetch QC Users
  Future<List<Map<String, dynamic>>> fetchQcUsers() async {
    return await ds.fetchQcUsers();
  }

  // ✅ Assign QC
  Future<void> assignQc({
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
    } catch (e) {
      debugPrint("Error assigning QC: $e");
    }
  }
}
