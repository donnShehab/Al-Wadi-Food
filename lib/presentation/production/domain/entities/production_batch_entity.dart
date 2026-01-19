import 'package:equatable/equatable.dart';

class ProductionBatchEntity extends Equatable {
  final String batchId;
  final String product;
  final int quantity;
  final DateTime startTime;
  final DateTime? endTime;
  final String line;
  final String operatorName;
  final List<String> images;
  final String notes;
  final String status;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  // ------------------------------
  // Manager Decision (optional)
  // ------------------------------
  /// "approved" | "hold" | "rejected"
  final String? managerDecisionStatus;
  final DateTime? managerDecisionAt;
  final String? managerDecisionById;
  final String? managerDecisionByName;
  final String? managerDecisionNote;

  const ProductionBatchEntity({
    required this.batchId,
    required this.product,
    required this.quantity,
    required this.startTime,
    this.endTime,
    required this.line,
    required this.operatorName,
    required this.images,
    required this.notes,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,

    // Manager Decision
    this.managerDecisionStatus,
    this.managerDecisionAt,
    this.managerDecisionById,
    this.managerDecisionByName,
    this.managerDecisionNote,
  });

  ProductionBatchEntity copyWith({
    String? batchId,
    String? product,
    int? quantity,
    DateTime? startTime,
    DateTime? endTime,
    String? line,
    String? operatorName,
    List<String>? images,
    String? notes,
    String? status,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,

    String? managerDecisionStatus,
    DateTime? managerDecisionAt,
    String? managerDecisionById,
    String? managerDecisionByName,
    String? managerDecisionNote,
  }) {
    return ProductionBatchEntity(
      batchId: batchId ?? this.batchId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      line: line ?? this.line,
      operatorName: operatorName ?? this.operatorName,
      images: images ?? this.images,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,

      managerDecisionStatus:
          managerDecisionStatus ?? this.managerDecisionStatus,
      managerDecisionAt: managerDecisionAt ?? this.managerDecisionAt,
      managerDecisionById: managerDecisionById ?? this.managerDecisionById,
      managerDecisionByName:
          managerDecisionByName ?? this.managerDecisionByName,
      managerDecisionNote: managerDecisionNote ?? this.managerDecisionNote,
    );
  }

  @override
  List<Object?> get props => [
    batchId,
    product,
    quantity,
    startTime,
    endTime,
    line,
    operatorName,
    images,
    notes,
    status,
    createdBy,
    createdAt,
    updatedAt,
    managerDecisionStatus,
    managerDecisionAt,
    managerDecisionById,
    managerDecisionByName,
    managerDecisionNote,
  ];
}
