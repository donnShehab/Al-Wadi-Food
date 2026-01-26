// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../domain/entities/trace_alert_entity.dart';
// import '../domain/entities/trace_alerts_load_result.dart';
// import '../domain/entities/trace_batch_entity.dart';
// import '../domain/entities/trace_bundle_entity.dart';
// import '../domain/entities/trace_event_entity.dart';
// import '../domain/entities/trace_qc_result_entity.dart';
// import '../domain/repos/traceability_repository.dart';
// import '../utils/trace_event_types.dart';
// import 'traceability_state.dart';

// class TraceabilityCubit extends Cubit<TraceabilityState> {
//   final TraceabilityRepository repo;

//   /// ✅ temporary debug for alerts
//   static const bool alertsDebugMode = true;

//   TraceabilityCubit(this.repo) : super(TraceabilityState.initial());

//   StreamSubscription<TraceBatchEntity?>? _batchSub;
//   StreamSubscription<List<TraceEventEntity>>? _eventsSub;
//   StreamSubscription<List<TraceQcResultEntity>>? _qcSub;

//   TraceBatchEntity? _latestBatch;
//   List<TraceEventEntity> _latestEvents = const [];
//   List<TraceQcResultEntity> _latestQc = const [];

//   // -------------------------
//   // Basic setters
//   // -------------------------
//   void updateQuery(String v) => emit(state.copyWith(query: v));
//   void updateStatusFilter(String v) => emit(state.copyWith(statusFilter: v));
//   void updateLineFilter(String v) => emit(state.copyWith(lineFilter: v));
//   void updateAlertsFilter(String filterKey) =>
//       emit(state.copyWith(alertsSelectedFilter: filterKey));

//   // -------------------------
//   // Init
//   // -------------------------
//   Future<void> init() async {
//     await Future.wait([
//       search(),
//       loadDashboard(),
//       loadAlerts(),
//     ]);
//   }

//   // -------------------------
//   // Alerts
//   // -------------------------
//   Future<void> loadAlerts({int limit = 120}) async {
//     try {
//       emit(state.copyWith(isLoadingAlerts: true, alertsError: null));

//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) throw Exception('Not signed in.');

//       final TraceAlertsLoadResult res =
//           await repo.loadAlerts(managerId: user.uid, limit: limit);

//       if (alertsDebugMode) {
//         // ignore: avoid_print
//         print(
//           "[Traceability][AlertsDebug] total=${res.stats.totalBatchesFetched} "
//           "| waiting_qc=${res.stats.waitingQcCount} "
//           "| oldestWaitingHours=${res.stats.oldestWaitingQcAgeHours} "
//           "| passed=${res.stats.passedCount} "
//           "| approvedDecisions=${res.stats.approvedDecisionsCount} "
//           "| alerts=${res.alerts.length}",
//         );
//       }

//       emit(state.copyWith(
//         isLoadingAlerts: false,
//         alerts: res.alerts,
//         alertsStats: res.stats,
//         alertsError: null,
//       ));
//     } catch (e) {
//       emit(state.copyWith(isLoadingAlerts: false, alertsError: e.toString()));
//     }
//   }

//   Future<void> markAlertReviewed({required String batchDocId, String? note}) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     // optimistic
//     final updated = state.alerts.map((a) {
//       if (a.docId == batchDocId) {
//         return a.copyWith(isReviewed: true, reviewedAt: DateTime.now());
//       }
//       return a;
//     }).toList();
//     emit(state.copyWith(alerts: updated));

//     await repo.markAlertReviewed(
//       managerId: user.uid,
//       managerName: user.displayName ?? 'Manager',
//       batchDocId: batchDocId,
//       note: note,
//     );

//     await loadAlerts();
//   }

//   // -------------------------
//   // Search (keep as-is if you already have your own)
//   // -------------------------
//   Future<void> search() async {
//     if (state.status == TraceabilityViewStatus.searching) return;

//     try {
//       emit(state.copyWith(status: TraceabilityViewStatus.searching, error: null));

//       final results = await repo.searchBatches(
//         query: state.query,
//         status: state.statusFilter,
//         line: state.lineFilter,
//         limit: 100,
//       ).timeout(
//         const Duration(seconds: 12),
//         onTimeout: () =>
//             throw Exception("Search timeout. Check network / Firestore rules / indexes."),
//       );

//       emit(state.copyWith(
//         status: TraceabilityViewStatus.loaded,
//         results: results,
//         error: null,
//       ));
//     } catch (e) {
//       emit(state.copyWith(
//         status: TraceabilityViewStatus.error,
//         error: e.toString(),
//         results: const [],
//       ));
//     }
//   }

//   // -------------------------
//   // Timeline selection streams
//   // -------------------------
//   Future<void> openBatch(String docId) async {
//     await _cancelSubs();

//     _latestBatch = null;
//     _latestEvents = const [];
//     _latestQc = const [];

//     emit(state.copyWith(
//       status: TraceabilityViewStatus.loadingBundle,
//       selectedDocId: docId,
//       selectedBundle: null,
//       error: null,
//       decisionError: null,
//     ));

//     _batchSub = repo.watchBatchByDocId(docId).listen((batch) {
//       _latestBatch = batch;
//       _rebuildBundle();
//     }, onError: (e) {
//       emit(state.copyWith(status: TraceabilityViewStatus.error, error: e.toString()));
//     });
//   }

//   void _attachStreamsUsingBatchId(String batchId) {
//     _eventsSub = repo.watchTraceEventsByBatchId(batchId).listen((events) {
//       _latestEvents = events;
//       _rebuildBundle();
//     }, onError: (e) {
//       emit(state.copyWith(status: TraceabilityViewStatus.error, error: e.toString()));
//     });

//     _qcSub = repo.watchQcResultsByBatchId(batchId).listen((qc) {
//       _latestQc = qc;
//       _rebuildBundle();
//     }, onError: (e) {
//       emit(state.copyWith(status: TraceabilityViewStatus.error, error: e.toString()));
//     });
//   }

//   void _rebuildBundle() {
//     final batch = _latestBatch;
//     if (batch == null) {
//       emit(state.copyWith(
//         status: TraceabilityViewStatus.error,
//         error: "Batch not found (doc missing). Check document ID.",
//       ));
//       return;
//     }

//     if (_eventsSub == null && _qcSub == null) {
//       _attachStreamsUsingBatchId(batch.batchId);
//     }

//     final bundle = TraceBundleEntity(
//       batch: batch,
//       events: _latestEvents,
//       qcResults: _latestQc,
//     );

//     emit(state.copyWith(
//       status: TraceabilityViewStatus.loaded,
//       selectedBundle: bundle,
//       error: null,
//     ));
//   }

//   void clearSelected() {
//     _cancelSubs();
//     emit(state.copyWith(clearSelected: true, status: TraceabilityViewStatus.loaded));
//   }

//   Future<void> loadDashboard() async {
//     try {
//       final dash = await repo.loadDashboardKpis(limit: 160);
//       emit(state.copyWith(dashboard: dash));
//     } catch (_) {}
//   }

//   // -----------------------------------------------------------------
//   // ✅ FIX FOR YOUR ERROR: add missing method used by TraceDecisionBar
//   // -----------------------------------------------------------------
//   Future<void> submitManagerDecision({
//     required String decision,
//     required String? note,
//   }) async {
//     if (state.isSubmittingDecision) return;

//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       emit(state.copyWith(decisionError: 'Not signed in.'));
//       return;
//     }

//     final bundle = state.selectedBundle;
//     final docId = state.selectedDocId;
//     if (bundle == null || docId == null) {
//       emit(state.copyWith(decisionError: 'No batch selected.'));
//       return;
//     }

//     emit(state.copyWith(isSubmittingDecision: true, decisionError: null));

//     final now = DateTime.now();

//     // ✅ optimistic update (instant UI feedback)
//     final optimisticBatch = bundle.batch.copyWith(
//       managerDecision: decision,
//       managerDecisionAt: now,
//       managerDecisionById: user.uid,
//       managerDecisionByName: user.displayName ?? 'Manager',
//       managerDecisionNote: note,
//     );
//     emit(state.copyWith(
//       selectedBundle: bundle.copyWith(batch: optimisticBatch),
//     ));

//     try {
//       // 1) Update batch fields
//       await repo.setManagerDecision(
//         batchDocId: docId,
//         decision: decision,
//         decisionAt: now,
//         managerId: user.uid,
//         managerName: user.displayName ?? 'Manager',
//         note: note,
//       );

//       // 2) Create trace event
//       String type;
//       String title;
//       String desc;

//       if (decision == 'approved') {
//         type = TraceEventTypes.approved;
//         title = 'Approved by Manager';
//         desc = (note == null || note.trim().isEmpty)
//             ? 'Manager approved the batch.'
//             : 'Manager approved: ${note.trim()}';
//       } else if (decision == 'rejected') {
//         type = TraceEventTypes.rejected;
//         title = 'Rejected by Manager';
//         desc = (note == null || note.trim().isEmpty)
//             ? 'Manager rejected the batch.'
//             : 'Manager rejected: ${note.trim()}';
//       } else {
//         type = TraceEventTypes.hold;
//         title = 'Held by Manager';
//         desc = (note == null || note.trim().isEmpty)
//             ? 'Manager placed the batch on hold.'
//             : 'Manager hold note: ${note.trim()}';
//       }

//       await repo.addTraceEvent(
//         batchId: bundle.batch.batchId,
//         type: type,
//         title: title,
//         description: desc,
//         actorId: user.uid,
//         actorName: user.displayName ?? 'Manager',
//         actorRole: 'manager',
//         timestamp: now,
//       );

//       emit(state.copyWith(isSubmittingDecision: false, decisionError: null));

//       // optional refresh alerts
//       await loadAlerts();
//     } catch (e) {
//       emit(state.copyWith(isSubmittingDecision: false, decisionError: e.toString()));
//     }
//   }

//   // -------------------------
//   // Alerts quick actions helper (used in alerts card)
//   // -------------------------
//   Future<void> submitDecisionFromAlert({
//     required TraceAlertEntity alert,
//     required String decision,
//     String? note,
//   }) async {
//     // reuse same logic by selecting and submitting
//     await openBatch(alert.docId);
//     await Future.delayed(const Duration(milliseconds: 20));
//     await submitManagerDecision(decision: decision, note: note);
//   }

//   Future<void> _cancelSubs() async {
//     await _batchSub?.cancel();
//     await _eventsSub?.cancel();
//     await _qcSub?.cancel();
//     _batchSub = null;
//     _eventsSub = null;
//     _qcSub = null;
//   }

//   @override
//   Future<void> close() async {
//     await _cancelSubs();
//     return super.close();
//   }
// }
