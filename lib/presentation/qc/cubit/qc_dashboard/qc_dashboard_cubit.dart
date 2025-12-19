import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'qc_dashboard_state.dart';

class QCDashboardCubit extends Cubit<QCDashboardState> {
  final ProductionRepository _productionRepository;
  final QCRepository _qcRepository;

  QCDashboardCubit(this._productionRepository, this._qcRepository)
    : super(QCDashboardInitial());


Future<void> _loadQCResults(int pendingCount) async {
    final qcResultsEither = await _qcRepository.getAllQCResults();

    qcResultsEither.fold(
      ifLeft: (failure) {
        emit(QCDashboardError(failure.message));
      },
      ifRight: (results) {
        final today = DateTime.now();

        final todayResults = results.where((r) {
          return r.createdAt.year == today.year &&
              r.createdAt.month == today.month &&
              r.createdAt.day == today.day;
        }).toList();

        final passedToday = todayResults
            .where((r) => r.result == AppConstants.qcResultPass)
            .length;

        final failedToday = todayResults
            .where((r) => r.result == AppConstants.qcResultFail)
            .length;

        emit(
          QCDashboardLoaded(
            pendingCount: pendingCount,
            passedToday: passedToday,
            failedToday: failedToday,
          ),
        );
      },
    );
  }
Future<void> loadDashboard() async {
    emit(QCDashboardLoading());

    try {
      /// 1️⃣ Pending QC
      final pendingEither = await _productionRepository.getBatchesByStatus(
        AppConstants.statusWaitingQC,
      );

      int pendingCount = 0;

      pendingEither.fold(
        ifLeft: (failure) {
          emit(QCDashboardError(failure));
          return;
        },
        ifRight: (batches) {
          pendingCount = batches.length;
        },
      );

      /// 2️⃣ QC Results
      final qcResultsEither = await _qcRepository.getAllQCResults();

      qcResultsEither.fold(
        ifLeft: (failure) {
          emit(QCDashboardError(failure.message));
        },
        ifRight: (results) {
          final today = DateTime.now();

          final todayResults = results.where((r) {
            return r.createdAt.year == today.year &&
                r.createdAt.month == today.month &&
                r.createdAt.day == today.day;
          }).toList();

          final passedToday = todayResults
              .where((r) => r.result == AppConstants.qcResultPass)
              .length;

          final failedToday = todayResults
              .where((r) => r.result == AppConstants.qcResultFail)
              .length;

          /// ✅ الآن كل القيم معرفة
          emit(
            QCDashboardLoaded(
              pendingCount: pendingCount,
              passedToday: passedToday,
              failedToday: failedToday,
            ),
          );
        },
      );
    } catch (e) {
      emit(QCDashboardError(e.toString()));
    }
  }

}
