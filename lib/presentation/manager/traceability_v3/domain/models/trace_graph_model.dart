// domain/models/trace_graph_model.dart

import 'trace_node_model.dart';
import 'trace_edge_model.dart';

class TraceGraphModel {
  final String rootNodeId;
  final Map<String, TraceNodeModel> nodes;
  final List<TraceEdgeModel> edges;

  TraceGraphModel({
    required this.rootNodeId,
    required this.nodes,
    required this.edges,
  });

  // ============================================================
  // 🔗 ADJACENCY HELPERS
  // ============================================================

  List<TraceEdgeModel> outgoing(String nodeId) {
    return edges.where((e) => e.from == nodeId).toList();
  }

  List<TraceEdgeModel> incoming(String nodeId) {
    return edges.where((e) => e.to == nodeId).toList();
  }

  // ============================================================
  // 🧭 PATH BUILDER (BFS)
  // Builds ALL shortest paths from a source node
  // ============================================================

  Map<String, List<String>> buildPathsFrom(String sourceNodeId) {
    final paths = <String, List<String>>{};
    final queue = <String>[];

    paths[sourceNodeId] = [sourceNodeId];
    queue.add(sourceNodeId);

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      for (final edge in outgoing(current)) {
        if (!paths.containsKey(edge.to)) {
          paths[edge.to] = [...paths[current]!, edge.to];
          queue.add(edge.to);
        }
      }
    }

    return paths;
  }

  // ============================================================
  // 🔍 DEPTH UTILITY
  // ============================================================

  int depthOf(String nodeId, Map<String, List<String>> paths) {
    final path = paths[nodeId];
    if (path == null) return 0;
    return path.length - 1;
  }
}
