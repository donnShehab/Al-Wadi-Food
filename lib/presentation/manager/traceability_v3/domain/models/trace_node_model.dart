import 'package:equatable/equatable.dart';

/// ============================================================
/// 🔹 TRACE NODE MODEL (V3)
/// Single atomic unit in the traceability graph
/// ============================================================

class TraceNodeModel extends Equatable {
  /// Unique node identifier
  final String id;

  /// Human-readable name (Batch #, Shipment #, etc.)
  final String label;

  /// Node category (batch, shipment, inventory, qc, supplier...)
  final String type;

  /// Current operational status (active, blocked, failed, completed)
  final String status;

  /// Optional quantity associated with the node
  final double? quantity;

  /// Optional unit (kg, box, pallet, etc.)
  final String? unit;

  /// Creation timestamp (used for timelines)
  final DateTime createdAt;

  /// Optional metadata for future extensibility
  final Map<String, dynamic> metadata;

  const TraceNodeModel({
    required this.id,
    required this.label,
    required this.type,
    required this.status,
    required this.createdAt,
    this.quantity,
    this.unit,
    this.metadata = const {},
  });

  // ============================================================
  // 🔁 Copy helper (Bloc-friendly)
  // ============================================================

  TraceNodeModel copyWith({
    String? id,
    String? label,
    String? type,
    String? status,
    double? quantity,
    String? unit,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return TraceNodeModel(
      id: id ?? this.id,
      label: label ?? this.label,
      type: type ?? this.type,
      status: status ?? this.status,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        label,
        type,
        status,
        quantity,
        unit,
        createdAt,
        metadata,
      ];
}

