import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/trace_alert_entity.dart';
import '../../domain/entities/trace_alerts_load_result.dart';
import '../../domain/entities/trace_batch_entity.dart';
import '../../domain/entities/trace_dashboard_entity.dart';
import '../../domain/entities/trace_event_entity.dart';
import '../../domain/entities/trace_qc_result_entity.dart';
import '../../domain/entities/trace_search_result_entity.dart';
import '../../domain/repos/traceability_repository.dart';
import '../../utils/trace_event_types.dart';
import '../../utils/trace_risk_engine.dart';
import '../datasources/traceability_firestore_ds.dart';
import '../mappers/traceability_firestore_mapper.dart';

class TraceabilityRepositoryImpl implements TraceabilityRepository {
  final TraceabilityFirestoreDataSource ds;

  TraceabilityRepositoryImpl({required this.ds});

  // -------------------------
  // ✅ Normalization helpers
  // -------------------------

  String _normalizeStatus(dynamic raw) {
    final s = (raw ?? '').toString().trim().toLowerCase();

    if (s.isEmpty) return 'unknown';

    if (s == 'in_progress' || s == 'inprogress' || s == 'in progress') {
      return AppConstants.statusInProgress;
    }

    if (s == 'waiting_qc' ||
        s == 'waitingqc' ||
        s == 'waiting qc' ||
        s == 'pending_qc' ||
        s == 'pendingqc' ||
        s == 'pending qc') {
      return AppConstants.statusWaitingQC;
    }

    if (s == 'passed' || s == 'pass' || s == 'qc_passed' || s == 'qc passed') {
      return AppConstants.statusPassed;
    }

    if (s == 'failed' || s == 'fail' || s == 'qc_failed' || s == 'qc failed') {
      return AppConstants.statusFailed;
    }

    // already canonical?
    if (s == AppConstants.statusInProgress ||
        s == AppConstants.statusWaitingQC ||
        s == AppConstants.statusPassed ||
        s == AppConstants.statusFailed) {
      return s;
    }

    return s;
  }

  String? _normalizeDecision(dynamic raw) {
    if (raw == null) return null;
    final s = raw.toString().trim().toLowerCase();
    if (s.isEmpty) return null;

    if (s == 'approved' || s == 'approve') return 'approved';
    if (s == 'rejected' || s == 'reject') return 'rejected';
    if (s == 'hold' || s == 'held' || s == 'on_hold' || s == 'on hold') {
      return 'hold';
    }
    return s;
  }

  DateTime _toDateTime(dynamic raw, {DateTime? fallback}) {
    if (raw is Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
    if (raw is String) {
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) return parsed;
    }
    return fallback ?? DateTime.now();
  }

  /// Same parsing as [_toDateTime], but allows returning null when no value exists.
  ///
  /// Use this for optional fields (e.g. reviewedAt) where "missing" must not be
  /// treated as "now".
  DateTime? _toDateTimeOrNull(dynamic raw) {
    if (raw == null) return null;
    if (raw is Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

  int _toInt(dynamic raw, {int fallback = 0}) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw) ?? fallback;
    return fallback;
  }

  int _countStringList(dynamic raw) {
    if (raw is! List) return 0;
    return raw.whereType<String>().where((e) => e.trim().isNotEmpty).length;
  }

  // -------------------------
  // Existing methods
  // -------------------------

  @override
  Future<List<TraceSearchResultEntity>> searchBatches({
    required String query,
    String status = 'All',
    String line = 'All',
    int limit = 80,
  }) async {
    final snap = await ds.fetchLatestBatches(limit: limit);
    final all = snap.docs.map(TraceabilityFirestoreMapper.mapSearchResult);

    final q = query.trim().toLowerCase();

    return all.where((r) {
      final matchesQuery = q.isEmpty
          ? true
          : r.batchCode.toLowerCase().contains(q) ||
                r.docId.toLowerCase().contains(q) ||
                r.product.toLowerCase().contains(q) ||
                r.line.toLowerCase().contains(q);

      final matchesStatus = status == 'All'
          ? true
          : r.status.toLowerCase() == status.toLowerCase();

      final matchesLine = line == 'All'
          ? true
          : r.line.toLowerCase() == line.toLowerCase();

      return matchesQuery && matchesStatus && matchesLine;
    }).toList();
  }

  @override
  Stream<TraceBatchEntity?> watchBatchByDocId(String docId) {
    return ds.watchBatchDoc(docId).map(TraceabilityFirestoreMapper.mapBatchDoc);
  }

  @override
  Stream<List<TraceEventEntity>> watchTraceEventsByBatchId(String batchId) {
    return ds.watchTraceEvents(batchId).map((snap) {
      final list = snap.docs
          .map(TraceabilityFirestoreMapper.mapTraceEvent)
          .toList();
      list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return list;
    });
  }

  @override
  Stream<List<TraceQcResultEntity>> watchQcResultsByBatchId(String batchId) {
    return ds.watchQcResults(batchId).map((snap) {
      return snap.docs.map(TraceabilityFirestoreMapper.mapQcResult).toList();
    });
  }

  @override
  Future<TraceDashboardEntity> loadDashboardKpis({int limit = 140}) async {
    final snap = await ds.fetchLatestBatches(limit: limit);

    int passed = 0;
    int failed = 0;
    int waiting = 0;

    for (final d in snap.docs) {
      final statusNorm = _normalizeStatus(d.data()['status']);
      if (statusNorm == AppConstants.statusPassed) passed++;
      if (statusNorm == AppConstants.statusFailed) failed++;
      if (statusNorm == AppConstants.statusWaitingQC) waiting++;
    }

    final total = snap.docs.length;
    final denom = (passed + failed);
    final passRate = denom == 0 ? 0.0 : (passed / denom) * 100.0;

    final eventsSnap = await ds.fetchLatestTraceEvents(limit: 50);
    final alerts = <String>[];

    for (final e in eventsSnap.docs) {
      final type = (e.data()['type'] ?? '').toString();
      if (type == TraceEventTypes.qcFailed ||
          type == TraceEventTypes.rejected) {
        final title = (e.data()['title'] ?? 'Alert').toString();
        alerts.add(title);
      }
      if (alerts.length >= 6) break;
    }

    return TraceDashboardEntity(
      totalBatches: total,
      passedCount: passed,
      failedCount: failed,
      waitingQcCount: waiting,
      passRate: passRate,
      latestAlerts: alerts,
    );
  }

  @override
  Future<void> setManagerDecision({
    required String batchDocId,
    required String decision,
    required DateTime decisionAt,
    required String managerId,
    required String managerName,
    required String? note,
  }) async {
    await ds.updateBatchManagerDecision(batchDocId, {
      'managerDecision': decision,
      'managerDecisionAt': Timestamp.fromDate(decisionAt),
      'managerDecisionById': managerId,
      'managerDecisionByName': managerName,
      'managerDecisionNote': note,
    });
  }

  @override
  Future<void> addTraceEvent({
    required String batchId,
    required String type,
    required String title,
    required String description,
    required String actorId,
    required String actorName,
    required String actorRole,
    DateTime? timestamp,
  }) async {
    final ts = timestamp ?? DateTime.now();
    await ds.createTraceEvent({
      'batchId': batchId,
      'type': type,
      'title': title,
      'description': description,
      'timestamp': Timestamp.fromDate(ts),
      'actorId': actorId,
      'actorName': actorName,
      'actorRole': actorRole,
    });
  }

  // -------------------------
  // ✅ Alerts (Reviewed merge + normalized SLA)
  // -------------------------

  @override
  Future<TraceAlertsLoadResult> loadAlerts({
    required String managerId,
    int limit = 120,
  }) async {
    final batchesSnap = await ds.fetchLatestBatches(limit: limit);
    final reviewsSnap = await ds.fetchAlertReviewsForManager(
      managerId: managerId,
      // ✅ reviews are lightweight; fetch more than batches to avoid
      // missing reviewed flags due to query limit.
      limit: limit < 400 ? 400 : limit,
    );

    final batchDocs = batchesSnap.docs;
    final reviewDocs = reviewsSnap.docs;

    final alerts = _buildAlertsFromSnapshots(
      batchDocs: batchDocs,
      reviewDocs: reviewDocs,
    );

    final stats = _computeStats(batchDocs);

    return TraceAlertsLoadResult(alerts: alerts, stats: stats);
  }

  TraceAlertsDebugStats _computeStats(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> batchDocs,
  ) {
    final now = DateTime.now();
    int waitingCount = 0;
    int oldestWaitingHours = 0;
    int passedCount = 0;
    int approvedDecisions = 0;

    for (final doc in batchDocs) {
      final data = doc.data();
      final status = _normalizeStatus(data['status']);
      final createdAt = _toDateTime(data['createdAt'], fallback: now);

      if (status == AppConstants.statusWaitingQC) {
        waitingCount++;
        final age = now.difference(createdAt).inHours;
        if (age > oldestWaitingHours) oldestWaitingHours = age;
      }

      if (status == AppConstants.statusPassed) {
        passedCount++;
      }

      final decision = _normalizeDecision(data['managerDecision']);
      if (decision == 'approved') {
        approvedDecisions++;
      }
    }

    return TraceAlertsDebugStats(
      totalBatchesFetched: batchDocs.length,
      waitingQcCount: waitingCount,
      oldestWaitingQcAgeHours: oldestWaitingHours,
      passedCount: passedCount,
      approvedDecisionsCount: approvedDecisions,
    );
  }

  List<TraceAlertEntity> _buildAlertsFromSnapshots({
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> batchDocs,
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> reviewDocs,
  }) {
    final reviewedMap = <String, DateTime>{}; // batchDocId -> reviewedAt

    for (final r in reviewDocs) {
      final d = r.data();
      final batchDocId = (d['batchDocId'] ?? '').toString();
      final reviewedAt = _toDateTimeOrNull(d['reviewedAt']);
      if (batchDocId.trim().isNotEmpty && reviewedAt != null) {
        reviewedMap[batchDocId] = reviewedAt;
      }
    }

    final alerts = <TraceAlertEntity>[];
    final now = DateTime.now();

    for (final doc in batchDocs) {
      final data = doc.data();
      final docId = doc.id;

      final batchId = (data['batchId'] ?? data['batchCode'] ?? doc.id)
          .toString();
      final product =
          (data['product'] ?? data['productName'] ?? data['productType'] ?? '-')
              .toString();
      final line = (data['line'] ?? data['lineName'] ?? '-').toString();

      final status = _normalizeStatus(data['status']);
      final quantity = _toInt(data['quantity'] ?? data['qty'] ?? data['count']);
      final createdAt = _toDateTime(data['createdAt'], fallback: now);

      // ✅ More reliable "age" base:
      // - when waiting_qc, measure from the time it ENTERED waiting_qc (usually updatedAt)
      // - fall back to createdAt if updatedAt missing
      final updatedAt = _toDateTime(data['updatedAt'], fallback: createdAt);
      final ageBase = status == AppConstants.statusWaitingQC
          ? updatedAt
          : createdAt;

      final managerDecision = _normalizeDecision(data['managerDecision']);
      final hasDecision =
          managerDecision != null && managerDecision.trim().isNotEmpty;

      final batchImages = _countStringList(
        data['images'] ?? data['batchImages'],
      );
      final qcImages = _countStringList(
        data['qcImages'] ?? data['qcEvidenceImages'] ?? data['qcPhotos'],
      );
      final totalImages = batchImages + qcImages;

      final failureReason =
          (data['failureReason'] ??
                  data['qcFailureReason'] ??
                  data['qcNote'] ??
                  data['failReason'])
              ?.toString()
              .trim();
      final missingFailureReason =
          failureReason == null || failureReason.isEmpty;

      final risk = TraceRiskEngine.compute(
        status: status,
        createdAt: ageBase,
        totalImages: totalImages,
        missingFailureReason: missingFailureReason,
      );

      final reviewedAt = reviewedMap[docId];
      final isReviewed = reviewedAt != null;

      // QC_FAILED
      if (status == AppConstants.statusFailed && !hasDecision) {
        alerts.add(
          TraceAlertEntity(
            docId: docId,
            batchId: batchId,
            product: product,
            line: line,
            status: status,
            quantity: quantity,
            createdAt: createdAt,
            riskScore: risk.score,
            riskLabel: risk.label,
            riskReasons: risk.reasons,
            alertType: 'QC_FAILED',
            message: 'QC Failed — no manager decision yet.',
            updatedAt: updatedAt,
            managerDecision: managerDecision,
            isReviewed: isReviewed,
            reviewedAt: reviewedAt,
            severityRank: 0,
          ),
        );
      }

      // EVIDENCE_MISSING
      if (status == AppConstants.statusFailed &&
          (missingFailureReason || totalImages == 0)) {
        final parts = <String>[];
        if (missingFailureReason) parts.add('failure reason');
        if (totalImages == 0) parts.add('images');

        alerts.add(
          TraceAlertEntity(
            docId: docId,
            batchId: batchId,
            product: product,
            line: line,
            status: status,
            quantity: quantity,
            createdAt: createdAt,
            riskScore: risk.score,
            riskLabel: risk.label,
            riskReasons: risk.reasons,
            alertType: 'EVIDENCE_MISSING',
            message: 'Evidence missing: ${parts.join(' & ')}.',
            updatedAt: updatedAt,
            managerDecision: managerDecision,
            isReviewed: isReviewed,
            reviewedAt: reviewedAt,
            severityRank: 1,
          ),
        );
      }

      // SLA (uses ageBase)
      if (status == AppConstants.statusWaitingQC) {
        final ageHours = now.difference(ageBase).inHours;
        if (ageHours >= 12) {
          alerts.add(
            TraceAlertEntity(
              docId: docId,
              batchId: batchId,
              product: product,
              line: line,
              status: status,
              quantity: quantity,
              createdAt: createdAt,
              riskScore: risk.score,
              riskLabel: risk.label,
              riskReasons: risk.reasons,
              alertType: 'SLA_CRITICAL',
              message: 'Waiting QC too long — SLA critical (≥ 12h).',
              updatedAt: updatedAt,
              managerDecision: managerDecision,
              isReviewed: isReviewed,
              reviewedAt: reviewedAt,
              severityRank: 2,
            ),
          );
        } else if (ageHours >= 6) {
          alerts.add(
            TraceAlertEntity(
              docId: docId,
              batchId: batchId,
              product: product,
              line: line,
              status: status,
              quantity: quantity,
              createdAt: createdAt,
              riskScore: risk.score,
              riskLabel: risk.label,
              riskReasons: risk.reasons,
              alertType: 'SLA_WARNING',
              message: 'Waiting QC too long — SLA warning (≥ 6h).',
              updatedAt: updatedAt,
              managerDecision: managerDecision,
              isReviewed: isReviewed,
              reviewedAt: reviewedAt,
              severityRank: 3,
            ),
          );
        }
      }

      // READY
      if (status == AppConstants.statusPassed &&
          managerDecision == 'approved') {
        alerts.add(
          TraceAlertEntity(
            docId: docId,
            batchId: batchId,
            product: product,
            line: line,
            status: status,
            quantity: quantity,
            createdAt: createdAt,
            riskScore: risk.score,
            riskLabel: risk.label,
            riskReasons: risk.reasons,
            alertType: 'READY',
            message: 'Ready for shipment — QC passed & manager approved.',
            updatedAt: updatedAt,
            managerDecision: managerDecision,
            isReviewed: isReviewed,
            reviewedAt: reviewedAt,
            severityRank: 9,
          ),
        );
      }
    }

    // Sort: unreviewed first, then severity, then risk desc, then updatedAt desc
    alerts.sort((a, b) {
      if (a.isReviewed != b.isReviewed) return a.isReviewed ? 1 : -1;
      final s = a.severityRank.compareTo(b.severityRank);
      if (s != 0) return s;
      final r = b.riskScore.compareTo(a.riskScore);
      if (r != 0) return r;
      return b.updatedAt.compareTo(a.updatedAt);
    });

    return alerts;
  }

  @override
  Future<void> markAlertReviewed({
    required String managerId,
    required String managerName,
    required String batchDocId,
    String? note,
  }) async {
    final docId = '${managerId}_$batchDocId';
    await ds.upsertAlertReviewDoc(
      docId: docId,
      data: {
        'managerId': managerId,
        'batchDocId': batchDocId,
        'reviewedAt': Timestamp.fromDate(DateTime.now()),
        'reviewedByName': managerName,
        'note': note,
      },
    );
  }
}
