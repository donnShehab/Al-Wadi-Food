import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/trace_event_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/trace_search_result_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TraceabilityRepository {
  final FirebaseFirestore firestore;

  TraceabilityRepository(this.firestore);

  Future<List<TraceSearchResultEntity>> searchBatches({
    required String query,
    required String status,
    required String line,
    int limit = 40,
  }) async {
    final snap = await firestore
        .collection(AppConstants.batchesCollection)
        .orderBy("createdAt", descending: true)
        .limit(limit)
        .get();

    return snap.docs
        .map((d) {
          final data = d.data();

          final batchId = data["batchId"] ?? d.id;
          final product = data["productType"] ?? data["product"] ?? "-";
          final lineName = data["line"] ?? "-";

          // ✅ Batch Name (Readable for Manager)
          final batchName = "$product • $lineName";

          return TraceSearchResultEntity(
            batchId: batchId,
            batchName: batchName,
            productName: product,
            lineName: lineName,
            status: data["status"] ?? "Unknown",
            risk: data["highRiskCount"] ?? 0,
            total: data["totalInspections"] ?? 0,
          );
        })
        .where((item) {
          final q = query.trim().toLowerCase();

          final matchQuery = q.isEmpty
              ? true
              : item.batchId.toLowerCase().contains(q) ||
                    item.batchName.toLowerCase().contains(q);

          final matchStatus = status == "All"
              ? true
              : item.status.toLowerCase() == status.toLowerCase();

          final matchLine = line == "All"
              ? true
              : item.lineName.toLowerCase() == line.toLowerCase();

          return matchQuery && matchStatus && matchLine;
        })
        .toList();
  }

  // ✅ Timeline Events
  Future<List<TraceEventEntity>> getTimeline(String batchId) async {
    final snap = await firestore
        .collection("trace_events")
        .where("batchId", isEqualTo: batchId)
        .orderBy("timestamp", descending: false)
        .get();

    return snap.docs.map((e) => TraceEventEntity.fromFirestore(e)).toList();
  }
}
