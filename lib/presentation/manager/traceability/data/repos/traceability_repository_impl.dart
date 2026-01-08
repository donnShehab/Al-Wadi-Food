import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/manager/traceability/data/datasources/traceability_firestore_ds.dart';
import 'package:alwadi_food/presentation/manager/traceability/data/mappers/traceability_firestore_mapper.dart';
import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_bundle_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_dashboard_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_event_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_search_result_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability/domain/repos/traceability_repository.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TraceabilityRepositoryImpl implements TraceabilityRepository {
  final TraceabilityFirestoreDataSource ds;
  final ProductionRepository productionRepo;
  final QCRepository qcRepo;

  TraceabilityRepositoryImpl({
    required this.ds,
    required this.productionRepo,
    required this.qcRepo,
  });

  @override
  Future<List<TraceSearchResultEntity>> searchBatches({
    required String query,
    String status = 'All',
    String line = 'All',
    int limit = 60,
  }) async {
    final snap = await ds.fetchLatestBatches(limit: limit);

    final all = snap.docs.map(TraceabilityFirestoreMapper.mapSearchResult);

    final q = query.trim().toLowerCase();
    return all.where((r) {
      final matchesQuery = q.isEmpty
          ? true
          : r.batchId.toLowerCase().contains(q) ||
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
  Future<List<TraceEventEntity>> getTimeline({required String batchId}) async {
    final snap = await ds.fetchTraceEvents(batchId: batchId);
    final events = snap.docs
        .map(TraceabilityFirestoreMapper.mapTraceEvent)
        .toList();

    events.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return events;
  }

  @override
  Future<TraceBundleEntity> loadTraceBundle({required String batchId}) async {
    final batchEither = await productionRepo.getBatchById(batchId);
    final ProductionBatchEntity? batch = _extractRight<ProductionBatchEntity>(
      batchEither,
    );

    if (batch == null) {
      throw Exception('Batch not found');
    }

    final qcEither = await qcRepo.getQCResultsByBatchId(batchId);
    final List<QCResultEntity> qcResults =
        _extractRight<List<QCResultEntity>>(qcEither) ?? [];

    final events = await getTimeline(batchId: batchId);

    final isFailed = batch.status == AppConstants.statusFailed;
    final isWaitingQc = batch.status == AppConstants.statusWaitingQC;
    final hasQcEvidence = qcResults.isNotEmpty;
    final isTimelineEmpty = events.isEmpty;

    return TraceBundleEntity(
      batch: batch,
      events: events,
      qcResults: qcResults,
      isFailed: isFailed,
      isWaitingQc: isWaitingQc,
      hasQcEvidence: hasQcEvidence,
      isTimelineEmpty: isTimelineEmpty,
    );
  }

  @override
  Future<TraceDashboardEntity> loadDashboardKpis({int limit = 120}) async {
    final snap = await ds.fetchLatestBatches(limit: limit);

    int passed = 0;
    int failed = 0;
    int waiting = 0;

    for (final d in snap.docs) {
      final status = (d.data()['status'] ?? 'unknown') as String;
      if (status == AppConstants.statusPassed) passed++;
      if (status == AppConstants.statusFailed) failed++;
      if (status == AppConstants.statusWaitingQC) waiting++;
    }

    final total = snap.docs.length;
    final denom = (passed + failed);
    final passRate = denom == 0 ? 0.0 : (passed / denom) * 100.0;

    // Latest alerts from recent events (QC_FAILED or REJECTED)
    final eventsSnap = await ds.fetchLatestTraceEvents(limit: 50);
    final alerts = <String>[];
    for (final e in eventsSnap.docs) {
      final type = (e.data()['type'] ?? '') as String;
      if (type == 'QC_FAILED' || type == 'REJECTED') {
        final title = (e.data()['title'] ?? 'Alert') as String;
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

  T? _extractRight<T>(dynamic either) {
    try {
      return either.fold((l) => null, (r) => r) as T?;
    } catch (_) {
      try {
        return either.match((l) => null, (r) => r) as T?;
      } catch (_) {
        return null;
      }
    }
  }
}
