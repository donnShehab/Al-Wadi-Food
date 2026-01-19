

import 'package:alwadi_food/presentation/manager/traceability_v2/data/models/trace_audit_dto.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/entities/trace_audit_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/repos/trace_audit_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TraceAuditRepositoryFirestore implements TraceAuditRepository {
  final FirebaseFirestore firestore;

  TraceAuditRepositoryFirestore(this.firestore);

  @override
  Future<List<TraceAuditEntity>> fetchAudits({
    DateTime? from,
    DateTime? to,
  }) async {
    Query query = firestore
        .collection('trace_audits')
        .orderBy('executedAt', descending: true);

    if (from != null) {
      query = query.where(
        'executedAt',
        isGreaterThanOrEqualTo: Timestamp.fromDate(from),
      );
    }

    if (to != null) {
      query = query.where(
        'executedAt',
        isLessThanOrEqualTo: Timestamp.fromDate(to),
      );
    }

    final snap = await query.get();

    return snap.docs.map(TraceAuditDto.fromDoc).toList();
  }
}
