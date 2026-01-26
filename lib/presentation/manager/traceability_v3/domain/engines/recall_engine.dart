import '../models/trace_graph_model.dart';
import '../models/trace_node_model.dart';
import '../models/recall_result_model.dart';

/// ============================================================
/// 🧠 Recall Engine — Traceability V3
/// Pure in-memory graph traversal
/// ============================================================

class RecallEngine {
  final TraceGraphModel graph;

  RecallEngine(this.graph);

  // ============================================================
  // 🔁 FORWARD TRACE (Source → Impact)
  // ============================================================

  RecallResultModel forwardRecall(String sourceNodeId) {
    final visited = <String>{};
    final affected = <TraceNodeModel>{};
    int maxDepth = 0;

    void dfs(String nodeId, int depth) {
      if (!visited.add(nodeId)) return;

      final node = graph.nodes[nodeId];
      if (node == null) return;

      affected.add(node);
      if (depth > maxDepth) maxDepth = depth;

      for (final edge in graph.outgoing(nodeId)) {
        dfs(edge.to, depth + 1);
      }
    }

    dfs(sourceNodeId, 0);

    final source = graph.nodes[sourceNodeId];
    if (source == null) {
      throw Exception('Source node not found in graph');
    }

    return RecallResultModel(
      source: source,
      affectedNodes: affected.toList(),
      maxDepth: maxDepth,
    );
  }

  // ============================================================
  // 🔁 BACKWARD TRACE (Impact → Source)
  // ============================================================

  Set<TraceNodeModel> reverseTrace(String nodeId) {
    final visited = <String>{};
    final sources = <TraceNodeModel>{};

    void dfs(String current) {
      if (!visited.add(current)) return;

      final node = graph.nodes[current];
      if (node != null) sources.add(node);

      for (final edge in graph.incoming(current)) {
        dfs(edge.from);
      }
    }

    dfs(nodeId);
    return sources;
  }
}
