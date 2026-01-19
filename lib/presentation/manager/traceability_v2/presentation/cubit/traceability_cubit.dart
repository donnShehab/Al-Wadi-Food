import 'package:alwadi_food/presentation/manager/traceability_v2/application/services/pdf/batch_passport_pdf_service.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/application/services/pdf/recall_execution_service.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/application/services/pdf/recall_summary_pdf_service.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/application/services/recall_severity.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/application/services/trace_traversal_service.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/entities/trace_recall_audit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repos/trace_graph_repository.dart';
import '../../domain/entities/trace_graph_entity.dart';
import '../../domain/entities/recall_impact_result.dart';



part 'traceability_state.dart';

class TraceabilityCubit extends Cubit<TraceabilityState> {
  final TraceGraphRepository repository;
  final BatchPassportPdfService passportPdf;
  final RecallSummaryPdfService recallPdf;

  TraceabilityCubit({
    required this.repository,
    required this.passportPdf,
    required this.recallPdf,
  }) : super(TraceabilityInitial());

  // ============================================================
  // 🔹 LOAD GRAPH
  // ============================================================

  Future<void> loadTraceGraph(String nodeId) async {
    emit(TraceabilityLoading());

    try {
      final graph = await repository.loadGraph(nodeId);
      emit(TraceabilityGraphLoaded(graph));
    } catch (e) {
      emit(TraceabilityError(e.toString()));
    }
  }

  // ============================================================
  // 🚨 RECALL ANALYSIS
  // ============================================================

  Future<void> analyzeRecall(String failedNodeId) async {
    emit(TraceabilityLoading());

    try {
      final graph = await repository.loadGraph(failedNodeId);
      final traversal = TraceTraversalService(graph);

      final impact = traversal.calculateRecallImpact(failedNodeId);
      final severity = RecallSeverityEngine.evaluate(impact);

      emit(
        RecallAnalysisReady(graph: graph, impact: impact, severity: severity),
      );
    } catch (e) {
      emit(TraceabilityError(e.toString()));
    }
  }

  // ============================================================
  // 📄 PDF EXPORTS
  // ============================================================

  Future<void> exportBatchPassport(String nodeId) async {
    final graph = await repository.loadGraph(nodeId);
    await passportPdf.generate(graph: graph, rootNodeId: nodeId);
  }

  Future<void> exportRecallReport(RecallImpactResult impact) async {
    await recallPdf.generate(impact: impact);
  }

  // ============================================================
  // 🔐 EXECUTE RECALL
  // ============================================================


  Future<void> executeRecall({
    required RecallImpactResult impact,
    required RecallSeverity severity,
    required String managerId,
  }) async {
    emit(TraceabilityLoading());

    try {
      // 1️⃣ Prepare locks
      final execution = RecallExecutionService();
      final updates = execution.prepareLocks(impact);

      // 2️⃣ Build audit record
      final audit = TraceRecallAudit(
        managerId: managerId,
        sourceNodeId: impact.source.nodeId,
        severity: severity,
        affectedNodeIds: updates.keys.toList(),
        executedAt: DateTime.now(),
      );

      // 3️⃣ Execute atomic transaction
      await repository.executeRecallTransaction(
        statusUpdates: updates,
        audit: audit,
      );

      emit(RecallExecuted(updates));
    } catch (e) {
      emit(TraceabilityError(e.toString()));
    }
  }

}
