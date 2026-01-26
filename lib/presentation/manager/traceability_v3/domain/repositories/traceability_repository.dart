import 'package:alwadi_food/presentation/manager/traceability_v3/domain/models/recall_audit_model.dart';

import '../models/trace_graph_model.dart';
import '../models/trace_node_model.dart';

/// ============================================================
/// 🔌 Traceability Repository (V3)
/// Domain contract only — no implementation details
/// ============================================================

abstract class TraceabilityV3Repository  {
  /// ------------------------------------------------------------
  /// 🔹 Load full traceability graph for a given root node
  /// ------------------------------------------------------------
  ///
  /// Example:
  /// - Input: Production Batch ID
  /// - Output: Graph containing all connected nodes & edges
  ///
  Future<TraceGraphModel> loadGraph({required String rootNodeId});

  /// ------------------------------------------------------------
  /// 🔹 Update status of multiple nodes atomically
  /// ------------------------------------------------------------
  ///
  /// Used during recall execution
  ///
  /// Example:
  /// {
  ///   "batch_123": "failed",
  ///   "shipment_88": "blocked"
  /// }
  ///
  Future<void> updateNodeStatuses({required Map<String, String> statusUpdates});

  /// ------------------------------------------------------------
  /// 🔹 Persist recall audit entry
  /// ------------------------------------------------------------
  ///
  /// Stored for compliance & investigations
  ///
  Future<void> createRecallAudit({required Map<String, dynamic> auditPayload});

  /// ------------------------------------------------------------
  /// 🔹 Fetch recall audit history (manager view)
  /// ------------------------------------------------------------
  ///
  /// Ordered by timestamp DESC
  ///
  Future<List<Map<String, dynamic>>> fetchRecallAudits({int limit = 50});
    Future<void> executeRecall({
    required Map<String, String> statusUpdates,
    required RecallAuditModel audit,
  });
}
