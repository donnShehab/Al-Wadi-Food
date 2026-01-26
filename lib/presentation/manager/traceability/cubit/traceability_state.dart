// import 'package:equatable/equatable.dart';

// import '../domain/entities/trace_alert_entity.dart';
// import '../domain/entities/trace_alerts_load_result.dart';
// import '../domain/entities/trace_bundle_entity.dart';
// import '../domain/entities/trace_dashboard_entity.dart';
// import '../domain/entities/trace_search_result_entity.dart';

// enum TraceabilityViewStatus { idle, searching, loadingBundle, loaded, error }

// class TraceabilityState extends Equatable {
//   final TraceabilityViewStatus status;

//   // Search
//   final String query;
//   final String statusFilter;
//   final String lineFilter;
//   final List<TraceSearchResultEntity> results;

//   // Timeline selection
//   final String? selectedDocId;
//   final TraceBundleEntity? selectedBundle;

//   // Dashboard
//   final TraceDashboardEntity dashboard;

//   // General error
//   final String? error;

//   // Alerts
//   final List<TraceAlertEntity> alerts;
//   final bool isLoadingAlerts;
//   final String? alertsError;
//   final String alertsSelectedFilter;
//   final TraceAlertsDebugStats alertsStats;

//   // ✅ Manager Decision (Timeline Decision Bar)
//   final bool isSubmittingDecision;
//   final String? decisionError;

//   const TraceabilityState({
//     required this.status,
//     required this.query,
//     required this.statusFilter,
//     required this.lineFilter,
//     required this.results,
//     required this.selectedDocId,
//     required this.selectedBundle,
//     required this.dashboard,
//     required this.error,
//     required this.alerts,
//     required this.isLoadingAlerts,
//     required this.alertsError,
//     required this.alertsSelectedFilter,
//     required this.alertsStats,
//     required this.isSubmittingDecision,
//     required this.decisionError,
//   });

//   factory TraceabilityState.initial() => TraceabilityState(
//     status: TraceabilityViewStatus.idle,
//     query: '',
//     statusFilter: 'All',
//     lineFilter: 'All',
//     results: const [],
//     selectedDocId: null,
//     selectedBundle: null,
//     dashboard: TraceDashboardEntity.empty(),
//     error: null,
//     alerts: const [],
//     isLoadingAlerts: false,
//     alertsError: null,
//     alertsSelectedFilter: 'all',
//     alertsStats: TraceAlertsDebugStats.empty(),
//     isSubmittingDecision: false,
//     decisionError: null,
//   );

//   TraceabilityState copyWith({
//     TraceabilityViewStatus? status,
//     String? query,
//     String? statusFilter,
//     String? lineFilter,
//     List<TraceSearchResultEntity>? results,
//     String? selectedDocId,
//     TraceBundleEntity? selectedBundle,
//     TraceDashboardEntity? dashboard,
//     String? error,
//     bool clearSelected = false,

//     // Alerts
//     List<TraceAlertEntity>? alerts,
//     bool? isLoadingAlerts,
//     String? alertsError,
//     String? alertsSelectedFilter,
//     TraceAlertsDebugStats? alertsStats,

//     // ✅ Decision
//     bool? isSubmittingDecision,
//     String? decisionError,
//   }) {
//     return TraceabilityState(
//       status: status ?? this.status,
//       query: query ?? this.query,
//       statusFilter: statusFilter ?? this.statusFilter,
//       lineFilter: lineFilter ?? this.lineFilter,
//       results: results ?? this.results,
//       selectedDocId: clearSelected
//           ? null
//           : (selectedDocId ?? this.selectedDocId),
//       selectedBundle: clearSelected
//           ? null
//           : (selectedBundle ?? this.selectedBundle),
//       dashboard: dashboard ?? this.dashboard,
//       error: error,
//       alerts: alerts ?? this.alerts,
//       isLoadingAlerts: isLoadingAlerts ?? this.isLoadingAlerts,
//       alertsError: alertsError,
//       alertsSelectedFilter: alertsSelectedFilter ?? this.alertsSelectedFilter,
//       alertsStats: alertsStats ?? this.alertsStats,
//       isSubmittingDecision: isSubmittingDecision ?? this.isSubmittingDecision,
//       decisionError: decisionError,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     status,
//     query,
//     statusFilter,
//     lineFilter,
//     results,
//     selectedDocId,
//     selectedBundle,
//     dashboard,
//     error,
//     alerts,
//     isLoadingAlerts,
//     alertsError,
//     alertsSelectedFilter,
//     alertsStats,
//     isSubmittingDecision,
//     decisionError,
//   ];
// }
