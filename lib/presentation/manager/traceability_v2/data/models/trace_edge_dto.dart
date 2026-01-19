import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/trace_edge_entity.dart';
import '../../domain/enums/trace_edge_type.dart';

class TraceEdgeDto {
  /// Firestore document ID
  final String refId;

  /// Source node
  final String fromNodeId;

  /// Target node
  final String toNodeId;

  /// Relationship type
  final TraceEdgeType type;

  /// Quantity transferred
  final double quantity;

  /// Measurement unit
  final String unit;

  /// Creation timestamp
  final DateTime createdAt;

  /// Optional note (loss reason, machine, etc.)
  final String? note;

  /// Optional metadata
  final Map<String, dynamic> metadata;

  TraceEdgeDto({
    required this.refId,
    required this.fromNodeId,
    required this.toNodeId,
    required this.type,
    required this.quantity,
    required this.unit,
    required this.createdAt,
    this.note,
    this.metadata = const {},
  });

  // ============================================================
  // 🔄 FIRESTORE → DTO
  // ============================================================

  factory TraceEdgeDto.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;

    return TraceEdgeDto(
      refId: doc.id,
      fromNodeId: data['fromNodeId'] as String,
      toNodeId: data['toNodeId'] as String,
      type: TraceEdgeTypeX.fromKey(data['type'] as String),
      quantity: (data['quantity'] as num).toDouble(),
      unit: data['unit'] as String? ?? 'kg', // ✅ SAFE DEFAULT
      note: data['note'] as String?,
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // ============================================================
  // 🔁 DTO → DOMAIN
  // ============================================================

  TraceEdgeEntity toEntity() {
    return TraceEdgeEntity(
      edgeId: refId,
      fromNodeId: fromNodeId,
      toNodeId: toNodeId,
      type: type, // ✅ FIXED
      quantity: quantity,
      unit: unit, // ✅ FIXED
      createdAt: createdAt,
      note: note,
      metadata: metadata,
    );
  }
}
