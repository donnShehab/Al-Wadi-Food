import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/trace_node_entity.dart';
import '../../domain/enums/trace_node_type.dart';

class TraceNodeDto {
  /// Firestore document ID
  final String refId;

  /// Business-level node ID
  final String nodeId;

  /// Node category
  final TraceNodeType type;

  /// Human-readable label
  final String label;

  /// Quantity represented by this node
  final double quantity;

  /// Measurement unit (kg, pcs, L, etc.)
  final String unit;

  /// Operational status (approved / failed / blocked / pending)
  final String status;

  /// Creation timestamp
  final DateTime createdAt;

  TraceNodeDto({
    required this.refId,
    required this.nodeId,
    required this.type,
    required this.label,
    required this.quantity,
    required this.unit,
    required this.status,
    required this.createdAt,
  });

  // ============================================================
  // 🔄 FIRESTORE → DTO
  // ============================================================

  factory TraceNodeDto.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return TraceNodeDto(
      refId: doc.id,
      nodeId: data['nodeId'] as String,
      type: TraceNodeTypeX.fromKey(data['type'] as String),
      label: data['label'] as String? ?? data['nodeId'],
      quantity: (data['quantity'] as num?)?.toDouble() ?? 0.0,
      unit: data['unit'] as String? ?? 'kg', // ✅ SAFE DEFAULT
      status: data['status'] as String? ?? 'approved', // ✅ SAFE DEFAULT
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // ============================================================
  // 🔁 DTO → DOMAIN
  // ============================================================

  TraceNodeEntity toEntity() {
    return TraceNodeEntity(
      refId: refId,
      nodeId: nodeId,
      label: label,
      type: type,
      quantity: quantity,
      unit: unit,
      status: status, // ✅ FIXED
      createdAt: createdAt,
    );
  }
}
