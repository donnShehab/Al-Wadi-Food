import 'package:equatable/equatable.dart';

class TraceEventEntity extends Equatable {
  final String id;
  final String batchId; // IMPORTANT: link id across collections

  final String type; // CREATED, SENT_TO_QC, QC_PASSED, QC_FAILED, ...
  final String title;
  final String description;

  final DateTime timestamp;
  final String actorName;
  final String actorRole;

  const TraceEventEntity({
    required this.id,
    required this.batchId,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.actorName,
    required this.actorRole,
  });

  @override
  List<Object?> get props => [
    id,
    batchId,
    type,
    title,
    description,
    timestamp,
    actorName,
    actorRole,
  ];
}
