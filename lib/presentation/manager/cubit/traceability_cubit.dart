import 'package:alwadi_food/presentation/manager/cubit/traceability_state.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TraceabilityCubit extends Cubit<TraceabilityState> {
  final ProductionRepository _productionRepository;
  final QCRepository _qcRepository;

  TraceabilityCubit(this._productionRepository, this._qcRepository)
    : super(const TraceabilityInitial());

  Future<void> loadTraceabilityReport(String batchId) async {
    emit(const TraceabilityLoading());

    final batchResult = await _productionRepository.getBatchById(batchId);
    final qcResult = await _qcRepository.getQCResultsByBatchId(batchId);

    batchResult.fold(
      ifLeft: 
      (failure) => emit(TraceabilityError(failure)),
      ifRight:  (
      batch,
    ) {
      qcResult.fold(
        ifLeft: 
        (failure) => emit(TraceabilityError(failure.message)),
        ifRight: 
        (qcResults) => emit(TraceabilityLoaded(batch, qcResults)),
      );
    });
  }
}
