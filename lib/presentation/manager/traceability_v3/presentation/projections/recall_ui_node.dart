// presentation/projections/recall_ui_node.dart

class RecallUiNode {
  final String nodeId;
  final String label;
  final String type;
  final String status;

  /// Visualization
  final int depth;
  final bool isSource;
  final List<String> path;

  /// Timeline / styling helpers
  final DateTime createdAt;

  const RecallUiNode({
    required this.nodeId,
    required this.label,
    required this.type,
    required this.status,
    required this.depth,
    required this.isSource,
    required this.path,
    required this.createdAt,
  });
}
