// import 'package:equatable/equatable.dart';
// import 'trace_batch_entity.dart';
// import 'trace_event_entity.dart';
// import 'trace_qc_result_entity.dart';

// class TraceBundleEntity extends Equatable {
//   final TraceBatchEntity batch;
//   final List<TraceEventEntity> events;
//   final List<TraceQcResultEntity> qcResults;

//   const TraceBundleEntity({
//     required this.batch,
//     required this.events,
//     required this.qcResults,
//   });

//   bool get isFailed => batch.status == 'failed';
//   bool get isWaitingQc => batch.status == 'waiting_qc';

//   /// ✅ Add copyWith so cubit can do optimistic updates safely
//   TraceBundleEntity copyWith({
//     TraceBatchEntity? batch,
//     List<TraceEventEntity>? events,
//     List<TraceQcResultEntity>? qcResults,
//   }) {
//     return TraceBundleEntity(
//       batch: batch ?? this.batch,
//       events: events ?? this.events,
//       qcResults: qcResults ?? this.qcResults,
//     );
//   }

//   @override
//   List<Object?> get props => [batch, events, qcResults];
// }
