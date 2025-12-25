import 'dart:io';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_measurements_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'qc_state.dart';

class QCCubit extends Cubit<QCState> {
  final QCRepository _qcRepository;
  final ProductionRepository _productionRepository;
  final AuthRepository _authRepository;

  QCCubit(this._qcRepository, this._productionRepository, this._authRepository)
    : super(const QCInitial());
  Future<void> createQCResult({
    required String batchId,
    required bool passed,
    required QCMeasurementsEntity measurements,
    String? failureReason,
    required List<File> images,
  }) async {
    emit(const QCLoading());

    try {
      // ❗ reject لازم يكون معه سبب
      if (!passed && (failureReason == null || failureReason.isEmpty)) {
        emit(const QCError('Failure reason is required'));
        return;
      }

      final userId = _authRepository.getCurrentUserId();
      if (userId == null) {
        emit(const QCError('User not authenticated'));
        return;
      }

      final userEither = await _authRepository.getCurrentUser();

      await userEither.fold(
        ifLeft: (failure) async {
          emit(QCError(failure.message));
          return;
        },
        ifRight: (user) async {
          final qcResult = QCResultEntity(
            inspectionId: DateTime.now().millisecondsSinceEpoch.toString(),
            batchId: batchId,
            inspectorId: user.uid,
            inspectorName: user.name,
            temperature: 0,
            weight: 0,
            color: '',
            packaging: '',
            moisture: 0,
            texture: '',
            tasteTest: null,
            notes: '',
            images: const [],
            result: passed
                ? AppConstants.qcResultPass
                : AppConstants.qcResultFail,
            failureReason: failureReason,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _qcRepository.createQCResult(qcResult, images);

          await _productionRepository.updateBatchStatus(
            batchId,
            passed ? AppConstants.statusPassed : AppConstants.statusFailed,
          );

          emit(const QCSuccess('QC inspection completed successfully'));
          // ✅ Refresh dashboard 
          await loadQCDashboard();
          return;
        },
      );
    } catch (e) {
      emit(QCError(e.toString()));
    }
  }

  Future<void> loadQCResultsByBatchId(String batchId) async {
    emit(const QCLoading());
    final result = await _qcRepository.getQCResultsByBatchId(batchId);

    result.fold(
      ifLeft: (failure) => emit(QCError(failure.message)),
      ifRight: (results) => emit(QCResultsLoaded(results)),
    );
  }

  // Future<void> loadPendingBatches() async {
  //     emit(const QCLoading());

  //     final result = await _productionRepository.getBatchesByStatus('pending');

  //     result.fold(
  //       ifLeft: (failure) => emit(QCError(failure)),
  //       ifRight: (batches) => emit(QCPendingBatchesLoaded(batches)),
  //     );
  //   }
  Future<void> loadPendingBatches() async {
    emit(const QCLoading());

    final result = await _productionRepository.getBatchesByStatus(
      AppConstants.statusWaitingQC, // ✅ waiting_qc
    );

    result.fold(
      ifLeft: (failure) => emit(QCError(failure)),
      ifRight: (batches) => emit(QCPendingBatchesLoaded(batches)),
    );
  }

  Future<void> loadAllQCResults() async {
    emit(const QCLoading());
    final result = await _qcRepository.getAllQCResults();

    result.fold(
      ifLeft: (failure) => emit(QCError(failure.message)),
      ifRight: (results) => emit(QCResultsLoaded(results)),
    );
  }
Future<void> loadQCDashboard() async {
    emit(const QCLoading());

    final pendingEither = await _productionRepository.getBatchesByStatus(
      AppConstants.statusWaitingQC,
    );

    final resultsEither = await _qcRepository.getAllQCResults();

    pendingEither.fold(
      ifLeft: (failure) => emit(QCError(failure)),
      ifRight: (pendingBatches) {
        resultsEither.fold(
          ifLeft: (failure) => emit(QCError(failure.message)),
          ifRight: (results) {
            final now = DateTime.now();

            /// ✅ Filter today's inspections
            final todayResults = results
                .where(
                  (r) =>
                      r.createdAt.year == now.year &&
                      r.createdAt.month == now.month &&
                      r.createdAt.day == now.day,
                )
                .toList();

            final passedToday = todayResults
                .where((e) => e.result == AppConstants.qcResultPass)
                .length;

            final failedToday = todayResults
                .where((e) => e.result == AppConstants.qcResultFail)
                .length;

            /// ✅ Risk Logic
            String riskLevel = "low";
            final List<String> alerts = [];

            if (failedToday == 0) {
              riskLevel = "low";
              alerts.add("✅ No failures detected today. Quality is stable.");
            } else if (failedToday <= 2) {
              riskLevel = "medium";
              alerts.add(
                "⚠️ $failedToday failures detected today. Monitor closely.",
              );
            } else {
              riskLevel = "high";
              alerts.add("🚨 High Risk! $failedToday failures detected today.");
              alerts.add("🚨 Consider stopping production and investigating.");
            }

            /// ✅ Detect consecutive failures
            final last3 = todayResults.take(3).toList();
            final consecutiveFails =
                last3.length == 3 &&
                last3.every((e) => e.result == AppConstants.qcResultFail);

            if (consecutiveFails) {
              alerts.add(
                "🔥 3 consecutive failures detected! Immediate action required.",
              );
            }

            emit(
              QCDashboardLoaded(
                pendingCount: pendingBatches.length,
                passedToday: passedToday,
                failedToday: failedToday,
                recentResults: results.take(5).toList(),
                riskLevel: riskLevel,
                alerts: alerts,
              ),
            );
          },
        );
      },
    );
  }

}
