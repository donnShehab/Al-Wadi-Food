import 'trace_node_entity.dart';
import 'trace_edge_entity.dart';
import '../enums/trace_node_type.dart';

class TraceGraphEntity {
  final Map<String, TraceNodeEntity> nodes;
  final List<TraceEdgeEntity> edges;

  TraceGraphEntity({required this.nodes, required this.edges});

  // ============================================================
  // 🔎 BASIC ACCESS
  // ============================================================

  TraceNodeEntity? getNode(String nodeId) => nodes[nodeId];

  List<TraceEdgeEntity> outgoingEdges(String nodeId) =>
      edges.where((e) => e.fromNodeId == nodeId).toList();

  List<TraceEdgeEntity> incomingEdges(String nodeId) =>
      edges.where((e) => e.toNodeId == nodeId).toList();

  // ============================================================
  // 🧮 MASS BALANCE ENGINE (INDUSTRIAL CORE)
  // ============================================================

  double totalInputQuantity(String nodeId) => incomingEdges(
    nodeId,
  ).where((e) => !e.isLoss).fold(0.0, (s, e) => s + e.quantity);

  double totalOutputQuantity(String nodeId) => outgoingEdges(
    nodeId,
  ).where((e) => !e.isLoss).fold(0.0, (s, e) => s + e.quantity);

  double totalLossQuantity(String nodeId) => outgoingEdges(
    nodeId,
  ).where((e) => e.isLoss).fold(0.0, (s, e) => s + e.quantity);

  /// Core industrial rule:
  /// inputs ≈ outputs + losses
  bool validateMassBalance(String nodeId, {double tolerance = 0.001}) {
    final input = totalInputQuantity(nodeId);
    final output = totalOutputQuantity(nodeId);
    final loss = totalLossQuantity(nodeId);

    return (input - (output + loss)).abs() <= tolerance;
  }

  // ============================================================
  // 🚨 GRAPH INTEGRITY RULES
  // ============================================================

  List<String> validateGraph() {
    final errors = <String>[];

    for (final node in nodes.values) {
      final type = node.type;

      // RAW materials must not have inputs
      if (type == TraceNodeType.rawMaterial &&
          incomingEdges(node.nodeId).isNotEmpty) {
        errors.add('RAW node ${node.nodeId} has incoming edges (illegal).');
      }

      // SHIPMENTS must not have outputs
      if (type == TraceNodeType.shipment &&
          outgoingEdges(node.nodeId).isNotEmpty) {
        errors.add(
          'SHIPMENT node ${node.nodeId} has outgoing edges (illegal).',
        );
      }

      // PRODUCTION & INVENTORY must obey mass balance
      if (type == TraceNodeType.productionBatch ||
          type == TraceNodeType.inventoryLot) {
        if (!validateMassBalance(node.nodeId)) {
          errors.add('Mass balance violation at node ${node.nodeId}.');
        }
      }
    }

    return errors;
  }

  bool get isValid => validateGraph().isEmpty;

  // ============================================================
  // 🔁 TRACING
  // ============================================================

  /// Forward trace (seed → shelf)
  Set<String> forwardTrace(String startNodeId) {
    final visited = <String>{};

    void dfs(String id) {
      if (!visited.add(id)) return;
      for (final e in outgoingEdges(id)) {
        dfs(e.toNodeId);
      }
    }

    dfs(startNodeId);
    return visited;
  }

  /// Reverse trace (recall mode)
  Set<String> reverseTrace(String startNodeId) {
    final visited = <String>{};

    void dfs(String id) {
      if (!visited.add(id)) return;
      for (final e in incomingEdges(id)) {
        dfs(e.fromNodeId);
      }
    }

    dfs(startNodeId);
    return visited;
  }
}
