import 'package:alwadi_food/presentation/manager/traceability/domain/repos/traceability_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'traceability_state.dart';

class TraceabilityCubit extends Cubit<TraceabilityState> {
  final TraceabilityRepository repo;

  TraceabilityCubit(this.repo) : super(TraceabilityState.initial());

  void updateQuery(String v) => emit(state.copyWith(query: v));

  void updateStatusFilter(String v) => emit(state.copyWith(statusFilter: v));

  void updateLineFilter(String v) => emit(state.copyWith(lineFilter: v));

  Future<void> init() async {
    await Future.wait([search(), loadDashboard()]);
  }

  Future<void> search() async {
    try {
      emit(
        state.copyWith(status: TraceabilityViewStatus.searching, error: null),
      );

      final results = await repo.searchBatches(
        query: state.query,
        status: state.statusFilter,
        line: state.lineFilter,
        limit: 80,
      );

      emit(
        state.copyWith(status: TraceabilityViewStatus.loaded, results: results),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TraceabilityViewStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> openBatch(String batchId) async {
    try {
      emit(state.copyWith(status: TraceabilityViewStatus.loading, error: null));
      final bundle = await repo.loadTraceBundle(batchId: batchId);
      emit(
        state.copyWith(status: TraceabilityViewStatus.loaded, selected: bundle),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TraceabilityViewStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void clearSelected() => emit(state.copyWith(clearSelected: true));

  Future<void> loadDashboard() async {
    try {
      final dash = await repo.loadDashboardKpis(limit: 140);
      emit(state.copyWith(dashboard: dash));
    } catch (_) {
      // Dashboard is optional; don't break UX if it fails.
    }
  }
}
