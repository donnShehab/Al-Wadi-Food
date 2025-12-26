import 'package:equatable/equatable.dart';

class QCResultEntity extends Equatable {
  final String inspectionId;
  final String batchId;

  final String productionLine; 

  final String inspectorId;
  final String inspectorName;

  final double temperature;
  final double weight;
  final String color;
  final String packaging;
  final double moisture;
  final String texture;
  final String? tasteTest;
  final String notes;
  final List<String> images;
  final String result;
  final String? failureReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const QCResultEntity({
    required this.inspectionId,
    required this.batchId,
    required this.productionLine, 
    required this.inspectorId,
    required this.inspectorName,
    required this.temperature,
    required this.weight,
    required this.color,
    required this.packaging,
    required this.moisture,
    required this.texture,
    this.tasteTest,
    required this.notes,
    required this.images,
    required this.result,
    this.failureReason,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    inspectionId,
    batchId,
    productionLine, 
    inspectorId,
    inspectorName,
    temperature,
    weight,
    color,
    packaging,
    moisture,
    texture,
    tasteTest,
    notes,
    images,
    result,
    failureReason,
    createdAt,
    updatedAt,
  ];
}
