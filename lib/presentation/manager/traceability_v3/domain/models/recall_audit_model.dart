class RecallAuditModel {
  final String managerId;
  final String managerName;
  final String sourceNodeId;
  final int affectedCount;
  final int maxDepth;
  final DateTime executedAt;

  const RecallAuditModel({
    required this.managerId,
    required this.managerName,
    required this.sourceNodeId,
    required this.affectedCount,
    required this.maxDepth,
    required this.executedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'managerId': managerId,
      'managerName': managerName,
      'sourceNodeId': sourceNodeId,
      'affectedCount': affectedCount,
      'maxDepth': maxDepth,
      'executedAt':
          executedAt, // Firestore can store DateTime; or use Timestamp.fromDate(executedAt)
    };
  }

  Map<String, dynamic> toJson() => toFirestore();
}
