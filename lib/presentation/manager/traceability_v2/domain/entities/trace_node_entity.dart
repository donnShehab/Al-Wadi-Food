import '../enums/trace_node_type.dart';

class TraceNodeEntity {
  
  final String nodeId;
  final TraceNodeType type;

  /// Business reference (batch code, shipment ID, etc.)
  final String refId;

  /// Human-readable label
  final String label;

  /// Quantity currently represented by this node
  final double quantity;
  final String unit;

  /// Status: passed / failed / approved / blocked
  final String status;

  /// Creation timestamp (server-based)
  final DateTime createdAt;

  /// Optional structured metadata
  /// Example:
  /// {
  ///   "supplier": "Supplier A",
  ///   "line": "Line B",
  ///   "warehouse": "WH-01"
  /// }
  final Map<String, dynamic> metadata;

  const TraceNodeEntity({
    required this.nodeId,
    required this.type,
    required this.refId,
    required this.label,
    required this.quantity,
    required this.unit,
    required this.status,
    required this.createdAt,
    this.metadata = const {},
  });

  bool get isFailed => status.toLowerCase() == 'failed';
  bool get isApproved => status.toLowerCase() == 'approved';

  @override
  String toString() {
    return 'TraceNodeEntity('
        'nodeId: $nodeId, '
        'type: ${type.key}, '
        'refId: $refId, '
        'quantity: $quantity $unit, '
        'status: $status'
        ')';
  }
}
