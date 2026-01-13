import '../entities/trace_dashboard_entity.dart';
import '../entities/trace_search_result_entity.dart';
import '../entities/trace_batch_entity.dart';
import '../entities/trace_event_entity.dart';
import '../entities/trace_qc_result_entity.dart';
import '../entities/trace_alert_entity.dart';
import '../entities/trace_alerts_load_result.dart';

abstract class TraceabilityRepository {
  Future<List<TraceSearchResultEntity>> searchBatches({
    required String query,
    String status,
    String line,
    int limit,
  });

  /// Realtime streams
  Stream<TraceBatchEntity?> watchBatchByDocId(String docId);
  Stream<List<TraceEventEntity>> watchTraceEventsByBatchId(String batchId);
  Stream<List<TraceQcResultEntity>> watchQcResultsByBatchId(String batchId);

  Future<TraceDashboardEntity> loadDashboardKpis({int limit});

  /// Manager decision
  Future<void> setManagerDecision({
    required String batchDocId,
    required String decision,
    required DateTime decisionAt,
    required String managerId,
    required String managerName,
    required String? note,
  });

  Future<void> addTraceEvent({
    required String batchId,
    required String type,
    required String title,
    required String description,
    required String actorId,
    required String actorName,
    required String actorRole,
    DateTime? timestamp,
  });

  /// Alerts (batches + reviews merge in one call)
  Future<TraceAlertsLoadResult> loadAlerts({
    required String managerId,
    int limit,
  });

  Future<void> markAlertReviewed({
    required String managerId,
    required String managerName,
    required String batchDocId,
    String? note,
  });
}
