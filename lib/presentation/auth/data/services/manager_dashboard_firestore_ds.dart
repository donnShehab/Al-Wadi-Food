import 'package:alwadi_food/presentation/manager/domain/entities/manager_trend_day_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/manager_dashboard_entity.dart';

class ManagerDashboardFirestoreDataSource {
  final FirebaseFirestore firestore;

  ManagerDashboardFirestoreDataSource(this.firestore);

  // ============================================================
  // ✅ DASHBOARD MAIN
  // ============================================================
  Future<ManagerDashboardEntity> fetchDashboard() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final trend = await fetchQCTrendLast7Days();

    final batchesSnap = await firestore
        .collection(AppConstants.batchesCollection)
        .where(
          "startTime",
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where("startTime", isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    final batches = batchesSnap.docs.map((e) => e.data()).toList();
    final productionToday = batches.length;

    final unitsToday = batches.fold<int>(
      0,
      (sum, b) => sum + ((b["quantity"] ?? 0) as int),
    );

    final pendingQC = batches
        .where((b) => (b["status"] ?? "") == AppConstants.statusWaitingQC)
        .length;

    final qcSnap = await firestore
        .collection(AppConstants.qcResultsCollection)
        .where(
          "createdAt",
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where("createdAt", isLessThan: Timestamp.fromDate(endOfDay))
        .get();

    final inspections = qcSnap.docs.map((e) => e.data()).toList();
    final qcInspectionsToday = inspections.length;

    final int passedCount = inspections.where((i) {
      final result = i["result"] ?? i["qcResult"] ?? "";
      if (result == AppConstants.qcResultPass) return true;
      final passedBool = i["passed"];
      if (passedBool is bool && passedBool == true) return true;
      return false;
    }).length;

    final int failedCount = inspections.where((i) {
      final result = i["result"] ?? i["qcResult"] ?? "";
      if (result == AppConstants.qcResultFail) return true;
      final passedBool = i["passed"];
      if (passedBool is bool && passedBool == false) return true;
      return false;
    }).length;

    final passRate = qcInspectionsToday == 0
        ? 0.0
        : (passedCount / qcInspectionsToday) * 100;

    final highRiskAlerts = inspections.where((i) {
      final temp = (i["temperature"] ?? 0).toDouble();
      final moisture = (i["moisture"] ?? 0).toDouble();
      return temp > 10 || moisture > 15;
    }).length;

    final lineStats = <String, Map<String, int>>{};
    for (final b in batches) {
      final line = b["line"] ?? "Unknown";
      lineStats.putIfAbsent(line, () => {"count": 0});
      lineStats[line]!["count"] = (lineStats[line]!["count"] ?? 0) + 1;
    }

    final sortedLines = lineStats.entries.toList()
      ..sort(
        (a, b) => (b.value["count"] ?? 0).compareTo(a.value["count"] ?? 0),
      );

    final bestLineToday = sortedLines.isEmpty ? "-" : sortedLines.first.key;
    final worstLineToday = sortedLines.isEmpty ? "-" : sortedLines.last.key;

    final reasons = <String, int>{};
    for (final i in inspections) {
      final reason = i["failureReason"];
      if (reason != null && reason.toString().trim().isNotEmpty) {
        reasons[reason.toString()] = (reasons[reason.toString()] ?? 0) + 1;
      }
    }

    String mostRepeatedFailure = "-";
    if (reasons.isNotEmpty) {
      final sortedReasons = reasons.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      mostRepeatedFailure = sortedReasons.first.key;
    }

    final inspectors = <String, int>{};
    for (final i in inspections) {
      final inspector = (i["inspectorName"] ?? "Unknown").toString();
      inspectors[inspector] = (inspectors[inspector] ?? 0) + 1;
    }

    String bestInspector = "-";
    if (inspectors.isNotEmpty) {
      final sortedInspectors = inspectors.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      bestInspector = sortedInspectors.first.key;
    }

    return ManagerDashboardEntity(
      trend: trend,
      managerName: "shehab",
      managerRole: "Operations Manager",
      today: today,
      productionToday: productionToday,
      unitsToday: unitsToday,
      qcInspectionsToday: qcInspectionsToday,
      pendingQC: pendingQC,
      passRate: passRate,
      highRiskAlerts: highRiskAlerts,
      worstLineToday: worstLineToday,
      bestLineToday: bestLineToday,
      mostRepeatedFailure: mostRepeatedFailure,
      bestInspector: bestInspector,
    );
  }

  // ============================================================
  // ✅ Trend last 7 days
  // ============================================================
  Future<List<ManagerTrendDayEntity>> fetchQCTrendLast7Days() async {
    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));

    final snap = await firestore
        .collection(AppConstants.qcResultsCollection)
        .where("createdAt", isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .get();

    final data = snap.docs.map((e) => e.data()).toList();
    final List<ManagerTrendDayEntity> result = [];

    for (int i = 0; i < 7; i++) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 6 - i));

      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));

      final daily = data.where((item) {
        final createdAt = (item["createdAt"] as Timestamp).toDate();
        return !createdAt.isBefore(dayStart) && createdAt.isBefore(dayEnd);
      }).toList();

      final passed = daily.where((i) {
        final res = i["result"] ?? i["qcResult"] ?? "";
        if (res == AppConstants.qcResultPass) return true;
        final passedBool = i["passed"];
        if (passedBool is bool && passedBool == true) return true;
        return false;
      }).length;

      final failed = daily.where((i) {
        final res = i["result"] ?? i["qcResult"] ?? "";
        if (res == AppConstants.qcResultFail) return true;
        final passedBool = i["passed"];
        if (passedBool is bool && passedBool == false) return true;
        return false;
      }).length;

      result.add(
        ManagerTrendDayEntity(day: dayStart, passed: passed, failed: failed),
      );
    }

    return result;
  }

  // ============================================================
  // ✅ Today batches list
  // ============================================================
  Future<List<Map<String, dynamic>>> fetchTodayBatches() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snap = await firestore
        .collection(AppConstants.batchesCollection)
        .where(
          "startTime",
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where("startTime", isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy("startTime", descending: true)
        .get();

    return snap.docs.map((e) => {"id": e.id, ...e.data()}).toList();
  }

  // ============================================================
  // ✅ Today inspections list
  // ============================================================
  Future<List<Map<String, dynamic>>> fetchTodayInspections() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final snap = await firestore
        .collection(AppConstants.qcResultsCollection)
        .where(
          "createdAt",
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where("createdAt", isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy("createdAt", descending: true)
        .get();

    return snap.docs.map((e) => {"id": e.id, ...e.data()}).toList();
  }

  // ============================================================
  // ✅ Production Today List
  // ============================================================
  Future<List<Map<String, dynamic>>> fetchProductionTodayList() async {
    return fetchTodayBatches();
  }

  // ============================================================
  // ✅ High Risk Alerts Today (UNRESOLVED ONLY)
  // ============================================================
  Future<List<Map<String, dynamic>>> fetchHighRiskAlertsToday() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    final snap = await firestore
        .collection(AppConstants.qcResultsCollection)
        .where("createdAt", isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where("createdAt", isLessThan: Timestamp.fromDate(end))
        .where("riskResolved", isEqualTo: false)
        .orderBy("createdAt", descending: true)
        .get();

    final data = snap.docs.map((d) => {"id": d.id, ...d.data()}).toList();

    return data.where((i) {
      final temp = (i["temperature"] ?? 0).toDouble();
      final moisture = (i["moisture"] ?? 0).toDouble();
      return temp > 10 || moisture > 15;
    }).toList();
  }

  // ============================================================
  // ✅ Pending QC
  // ============================================================
  Future<List<Map<String, dynamic>>> fetchPendingBatches() async {
    final snap = await firestore
        .collection(AppConstants.batchesCollection)
        .where("status", isEqualTo: AppConstants.statusWaitingQC)
        .orderBy("startTime", descending: true)
        .get();

    return snap.docs.map((d) => {"id": d.id, ...d.data()}).toList();
  }

  // ============================================================
  // ✅ Failed Inspections Today (UNRESOLVED ONLY)
  // ============================================================
  Future<List<Map<String, dynamic>>> fetchFailedInspectionsToday() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    final snap = await firestore
        .collection(AppConstants.qcResultsCollection)
        .where("createdAt", isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where("createdAt", isLessThan: Timestamp.fromDate(end))
        .where("riskResolved", isEqualTo: false)
        .orderBy("createdAt", descending: true)
        .get();

    final data = snap.docs.map((d) => {"id": d.id, ...d.data()}).toList();

    return data.where((i) {
      final result = (i["result"] ?? "").toString();
      return result == AppConstants.qcResultFail;
    }).toList();
  }

  // ============================================================
  // ✅ Resolve Alert (WITH NOTE + MANAGER NAME)
  // ============================================================
 Future<void> markAlertResolved({
    required String inspectionId,
    required String managerId,
    required String managerName,
    String? note,
  }) async {
    await firestore
        .collection(AppConstants.qcResultsCollection)
        .doc(inspectionId)
        .update({
          "riskResolved": true,

          // ✅ Save both
          "resolvedById": managerId,
          "resolvedByName": managerName,

          "resolvedAt": Timestamp.now(),
          "resolveNote": note ?? "",
          "updatedAt": Timestamp.now(),
        });
  }



   // ============================================================
  // ✅ Assign QC User
  // ============================================================
  Future<void> assignQcToAlert({
    required String inspectionId,
    required String qcId,
    required String qcName,
  }) async {
    await firestore
        .collection(AppConstants.qcResultsCollection)
        .doc(inspectionId)
        .update({
          "assignedQcId": qcId,
          "assignedQcName": qcName,
          "assignedAt": Timestamp.now(),
          "updatedAt": Timestamp.now(),
        });
  }
   // ============================================================
  // ✅ NEW: Fetch QC Users List (role == qc)
  // ============================================================
  Future<List<Map<String, dynamic>>> fetchQcUsers() async {
    final snap = await firestore
        .collection(AppConstants.usersCollection)
        .where("role", isEqualTo: "qc")
        .get();

    return snap.docs.map((d) => {"uid": d.id, ...d.data()}).toList();
  }

  // ============================================================
  // ✅ Resolved High Risk Alerts (HISTORY)
  // ============================================================
  Future<List<Map<String, dynamic>>> fetchResolvedHighRiskAlerts() async {
    final snap = await firestore
        .collection(AppConstants.qcResultsCollection)
        .where("riskResolved", isEqualTo: true)
        .orderBy("resolvedAt", descending: true)
        .get();

    final data = snap.docs.map((d) => {"id": d.id, ...d.data()}).toList();

    return data.where((i) {
      final temp = (i["temperature"] ?? 0).toDouble();
      final moisture = (i["moisture"] ?? 0).toDouble();
      return temp > 10 || moisture > 15;
    }).toList();
  }

}
