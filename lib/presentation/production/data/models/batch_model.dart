import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/batch_entity.dart';

class BatchModel extends BatchEntity {
  const BatchModel({
    required super.id,
    required super.code,
    required super.productName,
    required super.productionLine,
    required super.plannedQty,
    required super.producedQty,
    required super.unit,
    required super.status,
    required super.operatorId,
    super.operatorName,
    required super.materials,
    super.notes,
    required super.imageUrls,
    required super.qcStatus,
    super.lastQcBy,
    super.lastQcAt,
    super.rejectionReason,
    super.startedAt,
    super.completedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Serialize to Firestore/JSON
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'productName': productName,
      'productionLine': productionLine,
      'plannedQty': plannedQty,
      'producedQty': producedQty,
      'unit': unit,
      'status': status.name,
      'operatorId': operatorId,
      'operatorName': operatorName,
      'materials': materials
          .map(
            (m) => {
              'materialId': m.materialId,
              'name': m.name,
              'lotNumber': m.lotNumber,
              'quantity': m.quantity,
              'unit': m.unit,
            },
          )
          .toList(growable: false),
      'notes': notes,
      'imageUrls': imageUrls,
      'qcStatus': qcStatus.name,
      'lastQcBy': lastQcBy,
      'lastQcAt': _toTimestamp(lastQcAt),
      'rejectionReason': rejectionReason,
      'startedAt': _toTimestamp(startedAt),
      'completedAt': _toTimestamp(completedAt),
      'createdAt': _toTimestamp(createdAt),
      'updatedAt': _toTimestamp(updatedAt),
    };
  }

  /// From Firestore/JSON
  factory BatchModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return BatchModel(
      id: id,
      code: map['code'] ?? '',
      productName: map['productName'] ?? '',
      productionLine: map['productionLine'] ?? '',
      plannedQty: (map['plannedQty'] ?? 0) as int,
      producedQty: (map['producedQty'] ?? 0) as int,
      unit: map['unit'] ?? 'pcs',
      status: _statusFromString(map['status']),
      operatorId: map['operatorId'] ?? '',
      operatorName: map['operatorName'],
      materials: _materialsFrom(map['materials']),
      notes: map['notes'],
      imageUrls: _stringList(map['imageUrls']),
      qcStatus: _qcStatusFromString(map['qcStatus']),
      lastQcBy: map['lastQcBy'],
      lastQcAt: _fromTimestamp(map['lastQcAt']),
      rejectionReason: map['rejectionReason'],
      startedAt: _fromTimestamp(map['startedAt']),
      completedAt: _fromTimestamp(map['completedAt']),
      createdAt: _fromTimestamp(map['createdAt']) ?? DateTime.now(),
      updatedAt: _fromTimestamp(map['updatedAt']) ?? DateTime.now(),
    );
  }

  static List<MaterialUsage> _materialsFrom(dynamic raw) {
    if (raw is List) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(
            (e) => MaterialUsage(
              materialId: e['materialId'] ?? '',
              name: e['name'] ?? '',
              lotNumber: e['lotNumber'] ?? '',
              quantity: (e['quantity'] ?? 0.0) as double,
              unit: e['unit'] ?? 'kg',
            ),
          )
          .toList(growable: false);
    }
    return const [];
  }

  static List<String> _stringList(dynamic raw) =>
      (raw is List) ? raw.whereType<String>().toList() : [];

  static BatchStatus _statusFromString(String? value) {
    switch (value) {
      case 'planned':
        return BatchStatus.planned;
      case 'inProgress':
        return BatchStatus.inProgress;
      case 'completed':
        return BatchStatus.completed;
      case 'halted':
        return BatchStatus.halted;
      case 'cancelled':
        return BatchStatus.cancelled;
      default:
        return BatchStatus.planned;
    }
  }

  static QcStatus _qcStatusFromString(String? value) {
    switch (value) {
      case 'passed':
        return QcStatus.passed;
      case 'rejected':
        return QcStatus.rejected;
      default:
        return QcStatus.pending;
    }
  }

  static Timestamp _toTimestamp(DateTime? dt) =>
      Timestamp.fromDate(dt ?? DateTime.now());

  static DateTime? _fromTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    if (value is DateTime) return value;
    return null;
  }
}
