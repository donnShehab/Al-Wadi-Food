import 'trace_node_model.dart';

/// ============================================================
/// 🔥 Recall Result — Domain Output
/// ============================================================

class RecallResultModel {
  /// The node where the recall started
  final TraceNodeModel source;

  /// All affected nodes including the source
  final List<TraceNodeModel> affectedNodes;

  /// Traversal depth (used for UI scaling)
  final int maxDepth;

  const RecallResultModel({
    required this.source,
    required this.affectedNodes,
    required this.maxDepth,
  });

  /// Everything except the source
  List<TraceNodeModel> get downstream =>
      affectedNodes.where((n) => n.id != source.id).toList();

  bool get isCritical => downstream.length >= 3;
}
