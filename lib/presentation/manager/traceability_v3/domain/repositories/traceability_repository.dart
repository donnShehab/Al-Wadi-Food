import 'package:alwadi_food/presentation/manager/traceability_v3/domain/models/recall_audit_model.dart';

import '../models/trace_graph_model.dart';

/// ============================================================
/// 🔌 Traceability Repository (V3)
/// ============================================================
abstract class TraceabilityV3Repository {
  Future<TraceGraphModel> loadGraph({required String rootNodeId});

  Future<void> updateNodeStatuses({required Map<String, String> statusUpdates});

  Future<void> createRecallAudit({required Map<String, dynamic> auditPayload});

  Future<List<Map<String, dynamic>>> fetchRecallAudits({int limit = 50});

  Future<void> executeRecall({
    required Map<String, String> statusUpdates,
    required RecallAuditModel audit,
  });

  // ============================================================
  // ✅ Approval Workflow (Draft → Pending → Executed)
  // ============================================================

  /// Create a draft audit record (does NOT block nodes).
  Future<String> createRecallDraft({
    required Map<String, dynamic> draftPayload,
  });

  /// Move draft to pending approval.
  Future<void> submitRecallForApproval({required String auditId});

  /// Add an approval entry (arrayUnion).
  Future<void> addRecallApproval({
    required String auditId,
    required Map<String, dynamic> approval,
  });

  /// Execute recall AFTER approvals (blocks nodes + marks audit EXECUTED).
  Future<void> executeApprovedRecall({
    required String auditId,
    required Map<String, String> statusUpdates,
  });
}
