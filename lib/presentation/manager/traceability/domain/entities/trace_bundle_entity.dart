import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_event_entity.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:equatable/equatable.dart';

class TraceBundleEntity extends Equatable {
  final ProductionBatchEntity batch;
  final List<TraceEventEntity> events;
  final List<QCResultEntity> qcResults;

  /// Derived flags for Manager UX
  final bool isFailed;
  final bool isWaitingQc;
  final bool hasQcEvidence;
  final bool isTimelineEmpty;

  const TraceBundleEntity({
    required this.batch,
    required this.events,
    required this.qcResults,
    required this.isFailed,
    required this.isWaitingQc,
    required this.hasQcEvidence,
    required this.isTimelineEmpty,
  });

  @override
  List<Object?> get props => [
    batch,
    events,
    qcResults,
    isFailed,
    isWaitingQc,
    hasQcEvidence,
    isTimelineEmpty,
  ];
}
