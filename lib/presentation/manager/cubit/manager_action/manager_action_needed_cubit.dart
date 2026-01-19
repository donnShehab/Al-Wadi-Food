import 'package:alwadi_food/presentation/auth/data/services/manager_dashboard_firestore_ds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manager_action_needed_state.dart';

class ManagerActionNeededCubit extends Cubit<ManagerActionNeededState> {
  final ManagerDashboardFirestoreDataSource ds;

  static final ValueNotifier<int> pendingCountNotifier = ValueNotifier<int>(0);

  ManagerActionNeededCubit(this.ds) : super(ManagerActionNeededInitial());

  // ✅ تحميل البيانات وإصلاح خطأ الـ lastUpdated
  Future<void> loadActionNeeded() async {
    emit(ManagerActionNeededLoading());
    try {
      final highRisk = await ds.fetchHighRiskAlertsToday();
      final pending = await ds.fetchPendingBatches();
      final failed = await ds.fetchFailedInspectionsToday();

      pendingCountNotifier.value =
          highRisk.length + pending.length + failed.length;

      emit(
        ManagerActionNeededLoaded(
          highRiskAlerts: highRisk,
          pendingBatches: pending,
          failedInspections: failed,
          lastUpdated: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(ManagerActionNeededError(e.toString()));
    }
  }

  // ✅ حل التنبيه (Resolve)
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
      return false;
    }
  }

  // ✅ جلب مستخدمي الـ QC
  Future<List<Map<String, dynamic>>> fetchQcUsers() async {
    return await ds.fetchQcUsers();
  }

  // ✅ تعيين موظف QC
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
