import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductionBatchModel extends ProductionBatchEntity {
  const ProductionBatchModel({
    required super.batchId,
    required super.product,
    required super.quantity,
    required super.startTime,
    required super.endTime,
    required super.line,
    required super.operatorName,
    required super.images,
    required super.notes,
    required super.status,
    required super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductionBatchModel.fromJson(Map<String, dynamic> json) {
    return ProductionBatchModel(
      batchId: json['batchId'] as String,
      product: json['product'] as String,
      quantity: json['quantity'] as int,
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: (json['endTime'] as Timestamp).toDate(),
      line: json['line'] as String,
      operatorName: json['operatorName'] as String,
      images: List<String>.from(json['images'] as List),
      notes: json['notes'] as String,
      status: json['status'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batchId': batchId,
      'product': product,
      'quantity': quantity,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'line': line,
      'operatorName': operatorName,
      'images': images,
      'notes': notes,
      'status': status,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory ProductionBatchModel.fromEntity(ProductionBatchEntity entity) {
    return ProductionBatchModel(
      batchId: entity.batchId,
      product: entity.product,
      quantity: entity.quantity,
      startTime: entity.startTime,
      endTime: entity.endTime,
      line: entity.line,
      operatorName: entity.operatorName,
      images: entity.images,
      notes: entity.notes,
      status: entity.status,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ProductionBatchModel copyWith({
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
  }) {
    return ProductionBatchModel(
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
    );
  }
}
