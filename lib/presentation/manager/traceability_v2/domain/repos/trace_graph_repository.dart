import '../entities/trace_graph_entity.dart';
import '../entities/trace_recall_audit.dart';

abstract class TraceGraphRepository {
  Future<TraceGraphEntity> loadGraph(String rootNodeId);

  Future<void> createNode({
    required String nodeId,
    required Map<String, dynamic> payload,
  });

  Future<void> createEdge({
    required String edgeId,
    required Map<String, dynamic> payload,
  });

  /// 🔒 Execute recall + audit (atomic)
  Future<void> executeRecallTransaction({
    required Map<String, String> statusUpdates,
    required TraceRecallAudit audit,
  });
}
