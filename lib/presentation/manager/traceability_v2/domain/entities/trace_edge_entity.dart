import '../enums/trace_edge_type.dart';

class TraceEdgeEntity {
  /// Unique edge ID (Firestore doc ID or UUID)
  final String edgeId;

  /// Source node (from)
  final String fromNodeId;

  /// Target node (to)
  final String toNodeId;

  /// Relationship meaning
  final TraceEdgeType type;

  /// Quantity transferred on this edge
  final double quantity;
  final String unit;

  /// Timestamp of this transformation
  final DateTime createdAt;

  /// Optional explanation or reference
  /// Example:
  /// - "Used in mixing tank #3"
  /// - "Process loss due to evaporation"
  final String? note;

  /// Optional metadata (machine ID, operator, shift, etc.)
  final Map<String, dynamic> metadata;

  const TraceEdgeEntity({
    required this.edgeId,
    required this.fromNodeId,
    required this.toNodeId,
    required this.type,
    required this.quantity,
    required this.unit,
    required this.createdAt,
    this.note,
    this.metadata = const {},
  });

  bool get isLoss => type == TraceEdgeType.processLoss;

  @override
  String toString() {
    return 'TraceEdgeEntity('
        'from: $fromNodeId → to: $toNodeId, '
        'type: ${type.key}, '
        'qty: $quantity $unit'
        ')';
  }
}
