class QCResultEntity {
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

  /// ✅ Batch Context
  final String? productType;
  final String? line;
  final List<String>? batchImages;

  /// ✅ Resolve Flow
  final bool riskResolved;

  /// ✅ NEW (Manager)
  final String? resolvedById;
  final String? resolvedByName;

  final DateTime? resolvedAt;
  final String? resolveNote;

  /// ✅ Assign Flow
  final String? assignedQcId;
  final String? assignedQcName;
  final DateTime? assignedAt;

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

    /// ✅ Batch Context
    this.productType,
    this.line,
    this.batchImages,

    /// ✅ Resolve
    this.riskResolved = false,
    this.resolvedById,
    this.resolvedByName,
    this.resolvedAt,
    this.resolveNote,

    /// ✅ Assign
    this.assignedQcId,
    this.assignedQcName,
    this.assignedAt,
  });
}
