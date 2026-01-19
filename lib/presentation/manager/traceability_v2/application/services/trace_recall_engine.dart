
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/entities/recall_impact_result.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/entities/trace_graph_entity.dart';

/// ============================================================
/// 🧠 Recall Engine (Pure Domain Logic)
/// ============================================================

class TraceRecallEngine {
  final TraceGraphEntity graph;

  TraceRecallEngine(this.graph);

  /// ============================================================
  /// 🚨 Calculate Recall Impact Radius
  /// ============================================================

  RecallImpactResult calculate(String failedNodeId) {
    final sourceNode = graph.getNode(failedNodeId);
    if (sourceNode == null) {
      throw Exception('Source node not found: $failedNodeId');
    }

    final visited = <String>{};
    final impacts = <RecallImpactNode>[];

    void dfs(String nodeId, List<String> path) {
      if (!visited.add(nodeId)) return;

      final node = graph.getNode(nodeId);
      if (node == null) return;

      if (nodeId != failedNodeId) {
        impacts.add(
          RecallImpactNode(
            node: node,
            affectedQuantity: node.quantity,
            path: path,
          ),
        );
      }

      for (final edge in graph.outgoingEdges(nodeId)) {
        dfs(edge.toNodeId, [...path, edge.toNodeId]);
      }
    }

    dfs(failedNodeId, [failedNodeId]);

    return RecallImpactResult(source: sourceNode, impacts: impacts);
  }
}
