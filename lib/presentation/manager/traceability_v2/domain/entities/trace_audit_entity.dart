class TraceAuditEntity {
  final String auditId;
  final String sourceNodeId;
  final String managerId;
  final String severity;
  final DateTime executedAt;
  final int impactedCount;

  const TraceAuditEntity({
    required this.auditId,
    required this.sourceNodeId,
    required this.managerId,
    required this.severity,
    required this.executedAt,
    required this.impactedCount,
  });
}
