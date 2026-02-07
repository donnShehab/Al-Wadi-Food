class RecallAuditModel {
  final String managerId;
  final String managerName;
  final String sourceNodeId;
  final int affectedCount;
  final int maxDepth;

  /// ✅ Workflow fields (UI + compliance)
  final String status; // DRAFT | PENDING | EXECUTED
  final String severity; // LOW | MEDIUM | HIGH
  final int requiredApprovals;
  final List<Map<String, dynamic>> approvals;

  /// ✅ Optional evidence fields (may be updated later)
  final String? managerNote;
  final List<Map<String, dynamic>> attachments;

  /// ✅ Snapshot used for approval flow (no status updates until EXECUTED)
  final List<String> affectedNodeIds;

  /// Timestamps
  final DateTime? createdAt;
  final DateTime? submittedAt;
  final DateTime executedAt;

  const RecallAuditModel({
    required this.managerId,
    required this.managerName,
    required this.sourceNodeId,
    required this.affectedCount,
    required this.maxDepth,
    this.status = 'EXECUTED',
    this.severity = 'MEDIUM',
    this.requiredApprovals = 1,
    this.approvals = const [],
    this.managerNote,
    this.attachments = const [],
    this.affectedNodeIds = const [],
     this.createdAt,
    this.submittedAt,
    required this.executedAt,
  });

  /// Backward compatibility: existing callers used executedAt only.
  /// Provide a convenience factory for the old flow.
  factory RecallAuditModel.executed({
    required String managerId,
    required String managerName,
    required String sourceNodeId,
    required int affectedCount,
    required int maxDepth,
    required DateTime executedAt,
  }) {
    return RecallAuditModel(
      managerId: managerId,
      managerName: managerName,
      sourceNodeId: sourceNodeId,
      affectedCount: affectedCount,
      maxDepth: maxDepth,
      status: 'EXECUTED',
      severity: 'MEDIUM',
      requiredApprovals: 1,
      approvals: const [],
      createdAt: executedAt,
      executedAt: executedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'managerId': managerId,
      'managerName': managerName,
      'sourceNodeId': sourceNodeId,
      'affectedCount': affectedCount,
      'maxDepth': maxDepth,

      'status': status,
      'severity': severity,
      'requiredApprovals': requiredApprovals,
      'approvals': approvals,

      'managerNote': managerNote,
      'attachments': attachments,

      'affectedNodeIds': affectedNodeIds,

      'createdAt': createdAt,
      'submittedAt': submittedAt,
      'executedAt': executedAt,
    };
  }

  Map<String, dynamic> toJson() => toFirestore();
}
