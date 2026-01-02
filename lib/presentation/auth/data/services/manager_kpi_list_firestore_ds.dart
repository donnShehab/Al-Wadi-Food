import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';

class ManagerKpiListFirestoreDataSource {
  final FirebaseFirestore firestore;

  ManagerKpiListFirestoreDataSource(this.firestore);

  String? _extractBatchId(Map<String, dynamic> data) {
    final possibleKeys = [
      "batchId",
      "productionBatchId",
      "batchID",
      "batch_id",
    ];

    for (final key in possibleKeys) {
      final v = data[key];
      if (v != null && v.toString().trim().isNotEmpty) {
        return v.toString();
      }
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> fetchTodayBatches() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    final snap = await firestore
        .collection(AppConstants.batchesCollection)
        .where("startTime", isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where("startTime", isLessThan: Timestamp.fromDate(end))
        .orderBy("startTime", descending: true)
        .get();

    return snap.docs.map((d) => {"id": d.id, ...d.data()}).toList();
  }

  Future<List<Map<String, dynamic>>>
  fetchTodayInspectionsWithBatchInfo() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    final snap = await firestore
        .collection(AppConstants.qcResultsCollection)
        .where("createdAt", isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where("createdAt", isLessThan: Timestamp.fromDate(end))
        .orderBy("createdAt", descending: true)
        .get();

    final inspections = snap.docs
        .map((d) => {"id": d.id, ...d.data()})
        .toList();

    final batchIds = inspections
        .map((i) => _extractBatchId(i))
        .where((id) => id != null)
        .map((id) => id!)
        .toSet()
        .toList();

    if (batchIds.isEmpty) return inspections;

    final Map<String, Map<String, dynamic>> batchMap = {};

    for (int i = 0; i < batchIds.length; i += 10) {
      final chunk = batchIds.sublist(
        i,
        i + 10 > batchIds.length ? batchIds.length : i + 10,
      );

      final batchesSnap = await firestore
          .collection(AppConstants.batchesCollection)
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (final doc in batchesSnap.docs) {
        batchMap[doc.id] = doc.data();
      }
    }

    final merged = inspections.map((ins) {
      final batchId = _extractBatchId(ins);
      final batch = batchMap[batchId];

      if (batch == null) return ins;

      return {
        ...ins,
        "productType": batch["product"],
        "line": batch["line"],
        "quantity": batch["quantity"],
        "images": batch["images"],
      };
    }).toList();

    return merged;
  }

  Future<List<Map<String, dynamic>>> fetchHighRiskAlertsWithBatchInfo() async {
    final inspections = await fetchTodayInspectionsWithBatchInfo();

    return inspections.where((i) {
      final temp = (i["temperature"] ?? 0).toDouble();
      final moisture = (i["moisture"] ?? 0).toDouble();
      return temp > 10 || moisture > 15;
    }).toList();
  }

  // ✅ ✅ NEW: FAILED inspections for specific line (Worst line)
  Future<List<Map<String, dynamic>>> fetchFailedInspectionsByLineToday(
    String lineName,
  ) async {
    final inspections = await fetchTodayInspectionsWithBatchInfo();

    return inspections.where((i) {
      final line = (i["line"] ?? i["productionLine"] ?? "").toString();
      final result = (i["result"] ?? i["qcResult"] ?? "").toString();

      final isFail =
          result == AppConstants.qcResultFail ||
          (i["passed"] is bool && i["passed"] == false);

      return line == lineName && isFail;
    }).toList();
  }
}
