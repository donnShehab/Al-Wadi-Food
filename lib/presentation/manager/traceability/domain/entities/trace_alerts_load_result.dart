// import 'package:equatable/equatable.dart';
// import 'trace_alert_entity.dart';

// class TraceAlertsDebugStats extends Equatable {
//   final int totalBatchesFetched;
//   final int waitingQcCount;
//   final int oldestWaitingQcAgeHours; // 0 if none
//   final int passedCount;
//   final int approvedDecisionsCount;

//   const TraceAlertsDebugStats({
//     required this.totalBatchesFetched,
//     required this.waitingQcCount,
//     required this.oldestWaitingQcAgeHours,
//     required this.passedCount,
//     required this.approvedDecisionsCount,
//   });

//   factory TraceAlertsDebugStats.empty() => const TraceAlertsDebugStats(
//     totalBatchesFetched: 0,
//     waitingQcCount: 0,
//     oldestWaitingQcAgeHours: 0,
//     passedCount: 0,
//     approvedDecisionsCount: 0,
//   );

//   @override
//   List<Object?> get props => [
//     totalBatchesFetched,
//     waitingQcCount,
//     oldestWaitingQcAgeHours,
//     passedCount,
//     approvedDecisionsCount,
//   ];
// }

// class TraceAlertsLoadResult extends Equatable {
//   final List<TraceAlertEntity> alerts;
//   final TraceAlertsDebugStats stats;

//   const TraceAlertsLoadResult({required this.alerts, required this.stats});

//   @override
//   List<Object?> get props => [alerts, stats];
// }
