import 'package:flutter/foundation.dart';

@immutable
class BatchEntity {
  final String id;
  final String code;
  final String productName;
  final String productionLine;
  final int plannedQty;
  final int producedQty;
  final String unit;
  final BatchStatus status;
  final String operatorId;
  final String? operatorName;
  final List<MaterialUsage> materials;
  final String? notes;
  final List<String> imageUrls;
  final QcStatus qcStatus;
  final String? lastQcBy;
  final DateTime? lastQcAt;
  final String? rejectionReason;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BatchEntity({
    required this.id,
    required this.code,
    required this.productName,
    required this.productionLine,
    required this.plannedQty,
    required this.producedQty,
    required this.unit,
    required this.status,
    required this.operatorId,
    this.operatorName,
    required this.materials,
    this.notes,
    required this.imageUrls,
    required this.qcStatus,
    this.lastQcBy,
    this.lastQcAt,
    this.rejectionReason,
    this.startedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  BatchEntity copyWith({
    String? id,
    String? code,
    String? productName,
    String? productionLine,
    int? plannedQty,
    int? producedQty,
    String? unit,
    BatchStatus? status,
    String? operatorId,
    String? operatorName,
    List<MaterialUsage>? materials,
    String? notes,
    List<String>? imageUrls,
    QcStatus? qcStatus,
    String? lastQcBy,
    DateTime? lastQcAt,
    String? rejectionReason,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BatchEntity(
      id: id ?? this.id,
      code: code ?? this.code,
      productName: productName ?? this.productName,
      productionLine: productionLine ?? this.productionLine,
      plannedQty: plannedQty ?? this.plannedQty,
      producedQty: producedQty ?? this.producedQty,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      operatorId: operatorId ?? this.operatorId,
      operatorName: operatorName ?? this.operatorName,
      materials: materials ?? this.materials,
      notes: notes ?? this.notes,
      imageUrls: imageUrls ?? this.imageUrls,
      qcStatus: qcStatus ?? this.qcStatus,
      lastQcBy: lastQcBy ?? this.lastQcBy,
      lastQcAt: lastQcAt ?? this.lastQcAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum BatchStatus { planned, inProgress, completed, halted, cancelled }

enum QcStatus { pending, passed, rejected }

@immutable
class MaterialUsage {
  final String materialId;
  final String name;
  final String lotNumber;
  final double quantity;
  final String unit;

  const MaterialUsage({
    required this.materialId,
    required this.name,
    required this.lotNumber,
    required this.quantity,
    required this.unit,
  });

  MaterialUsage copyWith({
    String? materialId,
    String? name,
    String? lotNumber,
    double? quantity,
    String? unit,
  }) {
    return MaterialUsage(
      materialId: materialId ?? this.materialId,
      name: name ?? this.name,
      lotNumber: lotNumber ?? this.lotNumber,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}
