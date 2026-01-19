import 'package:alwadi_food/presentation/manager/traceability_v2/domain/entities/recall_impact_result.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/entities/trace_graph_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/entities/trace_node_entity.dart';



/// ============================================================
/// 🧠 TRACE TRAVERSAL & RECALL ENGINE
/// Pure domain logic — no Firestore, no UI
/// ============================================================

class TraceTraversalService {
  final TraceGraphEntity graph;

  TraceTraversalService(this.graph);

  // ============================================================
  // 🔁 FORWARD TRACE (Seed → Shelf)
  // ============================================================

  Set<TraceNodeEntity> forwardTrace(String startNodeId) {
    final visited = <String>{};
    final result = <TraceNodeEntity>{};

    void dfs(String nodeId) {
      if (!visited.add(nodeId)) return;

      final node = graph.getNode(nodeId);
      if (node != null) result.add(node);

      for (final edge in graph.outgoingEdges(nodeId)) {
        dfs(edge.toNodeId);
      }
    }

    dfs(startNodeId);
    return result;
  }

  // ============================================================
  // 🚨 RECALL IMPACT ANALYSIS (GRAPH-AWARE)
  // ============================================================

  RecallImpactResult calculateRecallImpact(String failedNodeId) {
    final visited = <String>{};
    final impacts = <RecallImpactNode>[];

    void dfs(String nodeId, List<String> path) {
      if (!visited.add(nodeId)) return;

      final node = graph.getNode(nodeId);
      if (node == null) return;

      impacts.add(
        RecallImpactNode(
          node: node,
          affectedQuantity: node.quantity,
          path: [...path, nodeId],
          isSource: nodeId == failedNodeId,
        ),
      );

      for (final edge in graph.outgoingEdges(nodeId)) {
        dfs(edge.toNodeId, [...path, nodeId]);
      }
    }

    dfs(failedNodeId, []);

    final sourceNode = impacts.firstWhere((i) => i.isSource).node;

    return RecallImpactResult(source: sourceNode, impacts: impacts);
  }

  // ============================================================
  // 🧨 STATUS CASCADE (OPTIONAL, INDUSTRIAL)
  // ============================================================

  Map<String, String> computeStatusCascade(String failedNodeId) {
    final impacted = forwardTrace(failedNodeId);
    final statusMap = <String, String>{};

    for (final node in impacted) {
      statusMap[node.nodeId] = node.nodeId == failedNodeId
          ? 'failed'
          : 'blocked';
    }

    return statusMap;
  }
}
