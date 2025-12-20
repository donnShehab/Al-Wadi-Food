import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_dashboard/qc_dashboard_state.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QCDashboardCubit extends Cubit<QCDashboardState> {
  final ProductionRepository _productionRepository;
  final QCRepository _qcRepository;

  QCDashboardCubit(this._productionRepository, this._qcRepository)
    : super(QCDashboardInitial());

  Future<void> loadDashboard() async {
    emit(QCDashboardLoading());

    try {
      // 1️⃣ Pending QC Batches
      final pendingEither = await _productionRepository.getBatchesByStatus(
        AppConstants.statusWaitingQC,
      );

      int pendingCount = 0;

      pendingEither.fold(
        ifLeft: (failure) => throw Exception(failure),
        ifRight: (batches) => pendingCount = batches.length,
      );

      // 2️⃣ All QC Results
      final qcResultsEither = await _qcRepository.getAllQCResults();

      qcResultsEither.fold(
        ifLeft: (failure) => throw Exception(failure.message),
        ifRight: (results) {
          final today = DateTime.now();

          final todayResults = results.where((r) {
            return _isSameDay(
              r.createdAt.toLocal(), // 🔥 مهم جدًا
              DateTime.now(),
            );
          }).toList();


          final passedToday = todayResults
              .where((r) => r.result == AppConstants.qcResultPass)
              .length;

          final failedToday = todayResults
              .where((r) => r.result == AppConstants.qcResultFail)
              .length;

          final recentResults = results.take(5).toList();

          emit(
            QCDashboardLoaded(
              pendingCount: pendingCount,
              passedToday: passedToday,
              failedToday: failedToday,
              recentResults: recentResults,
            ),
          );
        },
      );
    } catch (e) {
      emit(QCDashboardError(e.toString()));
    }
  

  }
    bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
