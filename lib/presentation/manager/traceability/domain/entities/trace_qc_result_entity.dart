import 'package:equatable/equatable.dart';

class TraceQcResultEntity extends Equatable {
  final String id;
  final String batchId;

  final String result; // pass / fail
  final String qcOfficerName;

  final String? failureReason;
  final Map<String, dynamic> measurements;
  final List<String> images;

  final DateTime createdAt;

  const TraceQcResultEntity({
    required this.id,
    required this.batchId,
    required this.result,
    required this.qcOfficerName,
    required this.createdAt,
    required this.measurements,
    required this.images,
    this.failureReason,
  });

  @override
  List<Object?> get props => [
    id,
    batchId,
    result,
    qcOfficerName,
    failureReason,
    measurements,
    images,
    createdAt,
  ];
}
