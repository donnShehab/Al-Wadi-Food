import 'package:alwadi_food/presentation/manager/traceability_v2/domain/enums/trace_node_type.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/application/services/recall_severity.dart';

class TraceRecallAudit {
  final String managerId;
  final String sourceNodeId;
  final RecallSeverity severity;
  final List<String> affectedNodeIds;
  final DateTime executedAt;

  const TraceRecallAudit({
    required this.managerId,
    required this.sourceNodeId,
    required this.severity,
    required this.affectedNodeIds,
    required this.executedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'managerId': managerId,
      'sourceNodeId': sourceNodeId,
      'severity': severity.name,
      'affectedNodeIds': affectedNodeIds,
      'executedAt': executedAt,
    };
  }
}
