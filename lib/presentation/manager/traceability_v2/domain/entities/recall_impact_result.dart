import 'trace_node_entity.dart';

/// ============================================================
/// 🔥 Recall Impact (Single Node)
/// ============================================================

class RecallImpactNode {
  final TraceNodeEntity node;

  /// Quantity impacted at this node
  final double affectedQuantity;

  /// Traversal path (source → ... → this node)
  final List<String> path;

  /// True only for the failed source node
  final bool isSource;

  const RecallImpactNode({
    required this.node,
    required this.affectedQuantity,
    required this.path,
    this.isSource = false,
  });
}

/// ============================================================
/// 🚨 Recall Impact Result (Domain Output)
/// ============================================================

class RecallImpactResult {
  /// Failed / recalled node
  final TraceNodeEntity source;

  /// All impacted nodes including source
  final List<RecallImpactNode> impacts;

  const RecallImpactResult({required this.source, required this.impacts});

  /// Everything except the source node
  List<RecallImpactNode> get downstream =>
      impacts.where((i) => !i.isSource).toList();
}
