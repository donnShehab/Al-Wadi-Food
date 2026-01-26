// presentation/cubit/traceability_cubit.dart

import 'package:alwadi_food/presentation/manager/traceability_v3/domain/models/trace_node_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/traceability_repository.dart';
import '../../domain/models/trace_graph_model.dart';
import '../../domain/models/recall_result_model.dart';
import '../../domain/models/recall_audit_model.dart';
import '../../domain/engines/recall_engine.dart';
import '../../domain/services/recall_severity_service.dart'; // ✅ NEW

import '../projections/recall_ui_mapper.dart';
import '../projections/recall_ui_projection.dart';

import 'traceability_state.dart';

class TraceabilityCubit extends Cubit<TraceabilityState> {
  final TraceabilityV3Repository repository;

  TraceabilityCubit(this.repository) : super(TraceabilityInitial());

  TraceGraphModel? _graph;

  // ============================================================
  // 🔹 LOAD TRACEABILITY GRAPH
  // ============================================================

  Future<void> loadGraph(String rootNodeId) async {
    emit(TraceabilityLoading());

    try {
      _graph = await repository.loadGraph(rootNodeId: rootNodeId);
      emit(TraceabilityGraphLoaded(_graph!));
    } catch (e) {
      emit(TraceabilityError(e.toString()));
    }
  }

  // ============================================================
  // 🚨 RUN RECALL ANALYSIS
  // ============================================================

  // Future<void> analyzeRecall(String sourceNodeId) async {
  //   if (_graph == null) {
  //     emit(const TraceabilityError('Graph not loaded'));
  //     return;
  //   }

  //   emit(TraceabilityLoading());

  //   try {
  //     final engine = RecallEngine(_graph!);

  //     // 1️⃣ Domain recall result
  //     final recallResult = engine.forwardRecall(sourceNodeId);

  //     // 2️⃣ Calculate severity (NEW)
  //     final severity = RecallSeverityService.evaluate(recallResult);

  //     // 3️⃣ Paths (simple BFS paths)
  //     final paths = _graph!.buildPathsFrom(sourceNodeId);

  //     // 4️⃣ UI Projection
  //     final projection = RecallUiMapper.fromDomain(recallResult, paths);

  //     emit(TraceabilityRecallReady(projection: projection, severity: severity));
  //   } catch (e) {
  //     emit(TraceabilityError(e.toString()));
  //   }
  // }

  // ============================================================
  // 🔐 EXECUTE RECALL (CONFIRMED LATER)
  // ============================================================

  Future<void> executeRecall({
    required RecallResultModel recallResult,
    required String managerId,
    required String managerName,
  }) async {
    emit(TraceabilityLoading());

    try {
      // 1️⃣ Prepare node status updates
      final updates = <String, String>{};

      for (final node in recallResult.affectedNodes) {
        updates[node.id] = 'BLOCKED';
      }

      // 2️⃣ Build audit model
      final audit = RecallAuditModel(
        managerId: managerId,
        managerName: managerName,
        sourceNodeId: recallResult.source.id,
        affectedCount: recallResult.affectedNodes.length,
        maxDepth: recallResult.maxDepth,
        executedAt: DateTime.now(),
      );

      // 3️⃣ Execute atomic recall
      await repository.executeRecall(statusUpdates: updates, audit: audit);

      emit(TraceabilityRecallExecuted());
    } catch (e) {
      emit(TraceabilityError(e.toString()));
    }
  }

  Future<void> analyzeRecall(String sourceNodeId) async {
    if (_graph == null) {
      emit(const TraceabilityError('Graph not loaded'));
      return;
    }

    // ✅ Allow analyzing by batchId (maps to internal node id if different)
    String resolvedId = sourceNodeId;

    if (!_graph!.nodes.containsKey(resolvedId)) {
      TraceNodeModel? match;
      for (final n in _graph!.nodes.values) {
        final batchId = (n.metadata['batchId'] ?? '').toString();
        if (batchId == sourceNodeId) {
          match = n;
          break;
        }
      }
      if (match != null) resolvedId = match.id;
    }

    if (!_graph!.nodes.containsKey(resolvedId)) {
      emit(
        TraceabilityError(
          'Cannot analyze: node "$sourceNodeId" not found in loaded graph',
        ),
      );
      return;
    }

    emit(TraceabilityLoading());

    try {
      final engine = RecallEngine(_graph!);

      final recallResult = engine.forwardRecall(resolvedId);
      final severity = RecallSeverityService.evaluate(recallResult);
      final paths = _graph!.buildPathsFrom(resolvedId);
      final projection = RecallUiMapper.fromDomain(recallResult, paths);

      emit(TraceabilityRecallReady(projection: projection, severity: severity));
    } catch (e) {
      emit(TraceabilityError(e.toString()));
    }
  }

  // ============================================================
  // 🔁 RESET
  // ============================================================

  void reset() {
    _graph = null;
    emit(TraceabilityInitial());
  }
}
