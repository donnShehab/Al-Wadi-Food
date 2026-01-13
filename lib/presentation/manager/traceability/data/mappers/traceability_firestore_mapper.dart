import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/trace_batch_entity.dart';
import '../../domain/entities/trace_event_entity.dart';
import '../../domain/entities/trace_qc_result_entity.dart';
import '../../domain/entities/trace_search_result_entity.dart';

class TraceabilityFirestoreMapper {
  static TraceSearchResultEntity mapSearchResult(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    final docId = doc.id;
    final batchCode = (data['batchId'] ?? doc.id).toString();

    final product = (data['product'] ?? data['productType'] ?? '-') as String;
    final line = (data['line'] ?? '-') as String;

    String? imageUrl = data['imageUrl'] as String?;
    final images = data['images'];
    if ((imageUrl == null || imageUrl.isEmpty) &&
        images is List &&
        images.isNotEmpty) {
      final v = images.first;
      if (v is String) imageUrl = v;
    }

    DateTime? createdAt;
    final createdAtTs = data['createdAt'];
    if (createdAtTs is Timestamp) createdAt = createdAtTs.toDate();

    int? quantity;
    final q = data['quantity'];
    if (q is num) quantity = q.toInt();

    final status = (data['status'] ?? 'unknown') as String;

    final int riskScore = status == 'failed'
        ? 3
        : status == 'waiting_qc'
        ? 1
        : 0;

    return TraceSearchResultEntity(
      docId: docId,
      batchCode: batchCode,
      product: product,
      line: line,
      status: status,
      imageUrl: imageUrl,
      quantity: quantity,
      createdAt: createdAt,
      riskScore: riskScore,
    );
  }

  static TraceBatchEntity? mapBatchDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;

    final docId = doc.id;
    final batchId = (data['batchId'] ?? doc.id).toString();

    final product = (data['product'] ?? data['productType'] ?? '-') as String;
    final line = (data['line'] ?? '-') as String;

    final quantity = (data['quantity'] is num)
        ? (data['quantity'] as num).toInt()
        : 0;

    DateTime createdAt = DateTime.now();
    final createdAtTs = data['createdAt'];
    if (createdAtTs is Timestamp) createdAt = createdAtTs.toDate();

    final status = (data['status'] ?? 'unknown') as String;
    final createdBy = (data['createdBy'] ?? '-') as String;

    final imagesRaw = data['images'];
    final images = (imagesRaw is List)
        ? imagesRaw.whereType<String>().toList()
        : <String>[];

    // Manager decision fields (optional)
    final managerDecision = data['managerDecision']?.toString();

    DateTime? managerDecisionAt;
    final mAt = data['managerDecisionAt'];
    if (mAt is Timestamp) managerDecisionAt = mAt.toDate();

    final managerDecisionById = data['managerDecisionById']?.toString();
    final managerDecisionByName = data['managerDecisionByName']?.toString();
    final managerDecisionNote = data['managerDecisionNote']?.toString();

    return TraceBatchEntity(
      docId: docId,
      batchId: batchId,
      product: product,
      line: line,
      quantity: quantity,
      createdAt: createdAt,
      status: status,
      createdBy: createdBy,
      images: images,
      managerDecision: managerDecision,
      managerDecisionAt: managerDecisionAt,
      managerDecisionById: managerDecisionById,
      managerDecisionByName: managerDecisionByName,
      managerDecisionNote: managerDecisionNote,
    );
  }

  static TraceEventEntity mapTraceEvent(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    DateTime ts = DateTime.now();
    final v = data['timestamp'];
    if (v is Timestamp) ts = v.toDate();

    return TraceEventEntity(
      id: doc.id,
      batchId: (data['batchId'] ?? '').toString(),
      type: (data['type'] ?? '').toString(),
      title: (data['title'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      timestamp: ts,
      actorName: (data['actorName'] ?? '-').toString(),
      actorRole: (data['actorRole'] ?? '-').toString(),
    );
  }

  static TraceQcResultEntity mapQcResult(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    DateTime createdAt = DateTime.now();
    final v = data['createdAt'];
    if (v is Timestamp) createdAt = v.toDate();

    final measurementsRaw = data['measurements'];
    final measurements = (measurementsRaw is Map)
        ? measurementsRaw.map((k, v) => MapEntry(k.toString(), v))
        : <String, dynamic>{};

    final imagesRaw = data['images'];
    final images = (imagesRaw is List)
        ? imagesRaw.whereType<String>().toList()
        : <String>[];

    return TraceQcResultEntity(
      id: doc.id,
      batchId: (data['batchId'] ?? '').toString(),
      result: (data['result'] ?? '').toString(), // pass/fail
      qcOfficerName: (data['qcOfficerName'] ?? data['qcOfficer'] ?? '-')
          .toString(),
      failureReason: data['failureReason']?.toString(),
      measurements: measurements,
      images: images,
      createdAt: createdAt,
    );
  }
}
