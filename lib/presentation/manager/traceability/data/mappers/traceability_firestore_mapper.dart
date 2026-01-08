import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_event_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_search_result_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TraceabilityFirestoreMapper {
  static TraceEventEntity mapTraceEvent(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    final ts = data['timestamp'];
    final DateTime timestamp = ts is Timestamp ? ts.toDate() : DateTime.now();

    return TraceEventEntity(
      id: doc.id,
      batchId: (data['batchId'] ?? '') as String,
      type: (data['type'] ?? '') as String,
      title: (data['title'] ?? '') as String,
      description: (data['description'] ?? '') as String,
      timestamp: timestamp,
      actorName: (data['actorName'] ?? '-') as String,
      actorRole: (data['actorRole'] ?? '-') as String,
    );
  }

  static TraceSearchResultEntity mapSearchResult(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    // ✅ Fallback rules for older documents:
    final product = (data['product'] ?? data['productType'] ?? '-') as String;
    final line = (data['line'] ?? '-') as String;

    // imageUrl fallback: imageUrl -> images.first
    String? imageUrl = data['imageUrl'] as String?;
    final images = data['images'];
    if ((imageUrl == null || imageUrl.isEmpty) &&
        images is List &&
        images.isNotEmpty) {
      final v = images.first;
      if (v is String) imageUrl = v;
    }

    final createdAtTs = data['createdAt'];
    final DateTime? createdAt = createdAtTs is Timestamp
        ? createdAtTs.toDate()
        : null;

    int? quantity;
    final q = data['quantity'];
    if (q is int) quantity = q;
    if (q is num) quantity = q.toInt();

    // Basic risk heuristic: failed => high, waiting_qc => medium
    final status = (data['status'] ?? 'unknown') as String;
    final int riskScore = status == 'failed'
        ? 3
        : status == 'waiting_qc'
        ? 1
        : 0;

    return TraceSearchResultEntity(
      batchId: (data['batchId'] ?? doc.id) as String,
      product: product,
      line: line,
      status: status,
      imageUrl: imageUrl,
      quantity: quantity,
      createdAt: createdAt,
      riskScore: riskScore,
    );
  }
}
