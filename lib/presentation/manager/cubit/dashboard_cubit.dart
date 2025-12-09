import 'package:alwadi_food/core/errors/failures.dart';
import 'package:alwadi_food/generated/intl/messages_en.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final ProductionRepository _productionRepository;
  final QCRepository _qcRepository;

  DashboardCubit(this._productionRepository, this._qcRepository)
    : super(const DashboardInitial());

  Future<void> loadDashboardData() async {
    emit(const DashboardLoading());

    final batchesResult = await _productionRepository.getAllBatches();
    final qcResult = await _qcRepository.getAllQCResults();

    batchesResult.fold(
      ifLeft: 
      (failure) => emit(DashboardError(failure)),
      ifRight: 
       (
      batches,
    ) {
      qcResult.fold(
              ifLeft: (failure) => emit(DashboardError(failure.message)),
          ifRight: 
 (
        qcResults,
      ) {
        /// حساب البيانات
        final totalBatches = batches.length;
        final passedBatches = batches.where((b) => b.status == 'passed').length;
        final failedBatches = batches.where((b) => b.status == 'failed').length;
        final inProgressBatches = batches
            .where((b) => b.status == 'in_progress')
            .length;
        final waitingQCBatches = batches
            .where((b) => b.status == 'waiting_qc')
            .length;

        final failureReasons = <String, int>{};
        for (var result in qcResults.where((r) => r.result == 'fail')) {
          final reason = result.failureReason ?? 'Unknown';
          failureReasons[reason] = (failureReasons[reason] ?? 0) + 1;
        }

        final productionByLine = <String, int>{};
        for (var batch in batches) {
          productionByLine[batch.line] =
              (productionByLine[batch.line] ?? 0) + 1;
        }

        emit(
          DashboardLoaded(
            DashboardData(
              totalBatches: totalBatches,
              passedBatches: passedBatches,
              failedBatches: failedBatches,
              inProgressBatches: inProgressBatches,
              waitingQCBatches: waitingQCBatches,
              failureReasons: failureReasons,
              productionByLine: productionByLine,
            ),
          ),
        );
      });
    });
  }
}
