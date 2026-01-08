import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QCResultModel extends QCResultEntity {
  const QCResultModel({
    required super.inspectionId,
    required super.batchId,
    required super.productionLine,
    required super.inspectorId,
    required super.inspectorName,
    required super.temperature,
    required super.weight,
    required super.color,
    required super.packaging,
    required super.moisture,
    required super.texture,
    super.tasteTest,
    required super.notes,
    required super.images,
    required super.result,
    super.failureReason,
    required super.createdAt,
    required super.updatedAt,

    super.productType,
    super.line,
    super.batchImages,

    super.riskResolved = false,
    super.resolvedById,
    super.resolvedByName,
    super.resolvedAt,
    super.resolveNote,

    super.assignedQcId,
    super.assignedQcName,
    super.assignedAt,
  });

  QCResultModel copyWith({
    String? inspectionId,
    String? batchId,
    String? productionLine,
    String? inspectorId,
    String? inspectorName,
    double? temperature,
    double? weight,
    String? color,
    String? packaging,
    double? moisture,
    String? texture,
    String? tasteTest,
    String? notes,
    List<String>? images,
    String? result,
    String? failureReason,
    DateTime? createdAt,
    DateTime? updatedAt,

    String? productType,
    String? line,
    List<String>? batchImages,

    bool? riskResolved,
    String? resolvedById,
    String? resolvedByName,
    DateTime? resolvedAt,
    String? resolveNote,

    String? assignedQcId,
    String? assignedQcName,
    DateTime? assignedAt,
  }) {
    return QCResultModel(
      inspectionId: inspectionId ?? this.inspectionId,
      batchId: batchId ?? this.batchId,
      productionLine: productionLine ?? this.productionLine,
      inspectorId: inspectorId ?? this.inspectorId,
      inspectorName: inspectorName ?? this.inspectorName,
      temperature: temperature ?? this.temperature,
      weight: weight ?? this.weight,
      color: color ?? this.color,
      packaging: packaging ?? this.packaging,
      moisture: moisture ?? this.moisture,
      texture: texture ?? this.texture,
      tasteTest: tasteTest ?? this.tasteTest,
      notes: notes ?? this.notes,
      images: images ?? this.images,
      result: result ?? this.result,
      failureReason: failureReason ?? this.failureReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,

      productType: productType ?? this.productType,
      line: line ?? this.line,
      batchImages: batchImages ?? this.batchImages,

      riskResolved: riskResolved ?? this.riskResolved,
      resolvedById: resolvedById ?? this.resolvedById,
      resolvedByName: resolvedByName ?? this.resolvedByName,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolveNote: resolveNote ?? this.resolveNote,

      assignedQcId: assignedQcId ?? this.assignedQcId,
      assignedQcName: assignedQcName ?? this.assignedQcName,
      assignedAt: assignedAt ?? this.assignedAt,
    );
  }
factory QCResultModel.fromJson(Map<String, dynamic> json) => QCResultModel(
    inspectionId: json['inspectionId'] as String,
    batchId: json['batchId'] as String,
    productionLine: json['productionLine'] as String? ?? "Unknown",
    inspectorId: json['inspectorId'] as String,
    inspectorName: json['inspectorName'] as String,
    temperature: (json['temperature'] as num).toDouble(),
    weight: (json['weight'] as num).toDouble(),
    color: json['color'] as String? ?? "",
    packaging: json['packaging'] as String? ?? "",
    moisture: (json['moisture'] as num).toDouble(),
    texture: json['texture'] as String? ?? "",
    tasteTest: json['tasteTest'] as String?,
    notes: json['notes'] as String? ?? "",
    images: (json['images'] as List?)?.cast<String>() ?? [],
    result: json['result'] as String,
    failureReason: json['failureReason'] as String?,
    createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),

    productType: json["productType"]?.toString(),
    line: json["line"]?.toString(),
    batchImages: (json["batchImages"] as List?)?.cast<String>(),

    riskResolved: json["riskResolved"] ?? false,

    /// ✅ NEW
    resolvedById: json["resolvedById"]?.toString(),
    resolvedByName: json["resolvedByName"]?.toString(),

    resolvedAt: json["resolvedAt"] is Timestamp
        ? (json["resolvedAt"] as Timestamp).toDate()
        : null,
    resolveNote: json["resolveNote"]?.toString(),

    assignedQcId: json["assignedQcId"]?.toString(),
    assignedQcName: json["assignedQcName"]?.toString(),
    assignedAt: json["assignedAt"] is Timestamp
        ? (json["assignedAt"] as Timestamp).toDate()
        : null,
  );


  Map<String, dynamic> toJson() => {
    'inspectionId': inspectionId,
    'batchId': batchId,
    'productionLine': productionLine,
    'inspectorId': inspectorId,
    'inspectorName': inspectorName,
    'temperature': temperature,
    'weight': weight,
    'color': color,
    'packaging': packaging,
    'moisture': moisture,
    'texture': texture,
    'tasteTest': tasteTest,
    'notes': notes,
    'images': images,
    'result': result,
    'failureReason': failureReason,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),

    'productType': productType,
    'line': line,
    'batchImages': batchImages,

    "riskResolved": riskResolved,

    /// ✅✅ NEW
    "resolvedById": resolvedById,
    "resolvedByName": resolvedByName,

    "resolvedAt": resolvedAt == null ? null : Timestamp.fromDate(resolvedAt!),
    "resolveNote": resolveNote,

    "assignedQcId": assignedQcId,
    "assignedQcName": assignedQcName,
    "assignedAt": assignedAt == null ? null : Timestamp.fromDate(assignedAt!),
  };

  factory QCResultModel.fromEntity(QCResultEntity entity) => QCResultModel(
    inspectionId: entity.inspectionId,
    batchId: entity.batchId,
    productionLine: entity.productionLine,
    inspectorId: entity.inspectorId,
    inspectorName: entity.inspectorName,
    temperature: entity.temperature,
    weight: entity.weight,
    color: entity.color,
    packaging: entity.packaging,
    moisture: entity.moisture,
    texture: entity.texture,
    tasteTest: entity.tasteTest,
    notes: entity.notes,
    images: entity.images,
    result: entity.result,
    failureReason: entity.failureReason,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,

    productType: entity.productType,
    line: entity.line,
    batchImages: entity.batchImages,

    riskResolved: entity.riskResolved,

    /// ✅✅ NEW
    resolvedById: entity.resolvedById,
    resolvedByName: entity.resolvedByName,

    resolvedAt: entity.resolvedAt,
    resolveNote: entity.resolveNote,

    assignedQcId: entity.assignedQcId,
    assignedQcName: entity.assignedQcName,
    assignedAt: entity.assignedAt,
  );
}
