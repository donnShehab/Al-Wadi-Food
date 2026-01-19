import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/trace_audit_entity.dart';

class TraceAuditDto {
  static TraceAuditEntity fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TraceAuditEntity(
      auditId: doc.id,
      sourceNodeId: data['sourceNodeId'],
      managerId: data['managerId'],
      severity: data['severity'],
      impactedCount: data['impactedCount'],
      executedAt: (data['executedAt'] as Timestamp).toDate(),
    );
  }
}
