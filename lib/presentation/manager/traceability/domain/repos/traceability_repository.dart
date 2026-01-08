import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_bundle_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_dashboard_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_event_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_search_result_entity.dart';

abstract class TraceabilityRepository {
  Future<List<TraceSearchResultEntity>> searchBatches({
    required String query,
    String status,
    String line,
    int limit,
  });

  Future<List<TraceEventEntity>> getTimeline({required String batchId});

  Future<TraceBundleEntity> loadTraceBundle({required String batchId});

  Future<TraceDashboardEntity> loadDashboardKpis({int limit});
}
