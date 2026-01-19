import '../entities/trace_audit_entity.dart';

abstract class TraceAuditRepository {
  Future<List<TraceAuditEntity>> fetchAudits({DateTime? from, DateTime? to});
}
