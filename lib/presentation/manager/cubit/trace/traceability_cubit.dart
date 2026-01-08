import 'package:alwadi_food/presentation/manager/domain/entities/trace_event_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/trace_search_result_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/repo/traceability_repository.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'traceability_state.dart';

class TraceabilityCubit extends Cubit<TraceabilityState> {
  final ProductionRepository productionRepo;
  final QCRepository qcRepo;
  final TraceabilityRepository traceRepo;

  TraceabilityCubit(this.productionRepo, this.qcRepo, this.traceRepo)
    : super(TraceabilityState.initial());

  void updateQuery(String q) => emit(state.copyWith(query: q));

  void updateStatusFilter(String v) => emit(state.copyWith(statusFilter: v));

  void updateLineFilter(String v) => emit(state.copyWith(lineFilter: v));

  // ✅ MAIN SEARCH
  Future<void> search() async {
    try {
      emit(state.copyWith(status: TraceabilityStatus.searching, error: null));

      final results = await traceRepo.searchBatches(
        query: state.query,
        status: state.statusFilter,
        line: state.lineFilter,
      );

      emit(
        state.copyWith(
          status: TraceabilityStatus.loaded,
          searchResults: results,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: TraceabilityStatus.error, error: e.toString()),
      );
    }
  }

  // ✅ Open batch trace
  Future<void> openBatchTrace(String batchId) async {
    try {
      emit(state.copyWith(status: TraceabilityStatus.loading, error: null));

      final batchEither = await productionRepo.getBatchById(batchId);
      final ProductionBatchEntity? batch = _extractRight(batchEither);

      if (batch == null) {
        emit(
          state.copyWith(
            status: TraceabilityStatus.error,
            error: "Batch not found",
          ),
        );
        return;
      }

      final qcEither = await qcRepo.getQCResultsByBatchId(batchId);
      final List<QCResultEntity> qcResults = _extractRight(qcEither) ?? [];

      final traceEvents = await traceRepo.getTimeline(batchId);

      emit(
        state.copyWith(
          status: TraceabilityStatus.loaded,
          selectedBatch: batch,
          qcResults: qcResults,
          traceEvents: traceEvents,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: TraceabilityStatus.error, error: e.toString()),
      );
    }
  }

  void clearSelected() {
    emit(state.copyWith(clearSelected: true, qcResults: [], traceEvents: []));
  }

  /// ✅ Universal Either extractor
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
