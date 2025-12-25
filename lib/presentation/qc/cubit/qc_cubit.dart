import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_measurements_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_recommendation_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_trend_day_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';

import 'qc_state.dart';

class QCCubit extends Cubit<QCState> {
  final QCRepository _qcRepository;
  final ProductionRepository _productionRepository;
  final AuthRepository _authRepository;

  QCCubit(this._qcRepository, this._productionRepository, this._authRepository)
    : super(const QCInitial());

  // ============================================================
  // ✅ 1) Create QC Result
  // ============================================================
  Future<void> createQCResult({
    required String batchId,
    required bool passed,
    required QCMeasurementsEntity measurements,
    String? failureReason,
    required List<File> images,
  }) async {
    emit(const QCLoading());

    try {
      /// ❗ Reject requires a reason
      if (!passed && (failureReason == null || failureReason.isEmpty)) {
        emit(const QCError('Failure reason is required'));
        return;
      }

      /// ✅ Current user
      final userId = _authRepository.getCurrentUserId();
      if (userId == null) {
        emit(const QCError('User not authenticated'));
        return;
      }

      final userEither = await _authRepository.getCurrentUser();

      await userEither.fold(
        ifLeft: (failure) async => emit(QCError(failure.message)),
        ifRight: (user) async {
          final qcResult = QCResultEntity(
            inspectionId: DateTime.now().millisecondsSinceEpoch.toString(),
            batchId: batchId,
            inspectorId: user.uid,
            inspectorName: user.name,

            // ✅ Measurements
            temperature: measurements.temperature,
            weight: measurements.weight,
            moisture: measurements.moisture,
            texture: measurements.texture,
            notes: measurements.notes,
            packaging: measurements.packaging,

            // extra
            color: '',
            tasteTest: null,

            images: const [],
            result: passed
                ? AppConstants.qcResultPass
                : AppConstants.qcResultFail,
            failureReason: failureReason,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          /// ✅ Save QC result
          await _qcRepository.createQCResult(qcResult, images);

          /// ✅ Update batch status
          await _productionRepository.updateBatchStatus(
            batchId,
            passed ? AppConstants.statusPassed : AppConstants.statusFailed,
          );

          emit(const QCSuccess('QC inspection completed successfully ✅'));

          /// ✅ Refresh dashboard instantly
          await loadQCDashboard();
        },
      );
    } catch (e) {
      emit(QCError(e.toString()));
    }
  }

  // ============================================================
  // ✅ 2) Pending Batches
  // ============================================================
  Future<void> loadPendingBatches() async {
    emit(const QCLoading());

    final result = await _productionRepository.getBatchesByStatus(
      AppConstants.statusWaitingQC,
    );

    result.fold(
      ifLeft: (failure) => emit(QCError(failure)),
      ifRight: (batches) => emit(QCPendingBatchesLoaded(batches)),
    );
  }

  // ============================================================
  // ✅ 3) QC Results by Batch
  // ============================================================
  Future<void> loadQCResultsByBatchId(String batchId) async {
    emit(const QCLoading());

    final result = await _qcRepository.getQCResultsByBatchId(batchId);

    result.fold(
      ifLeft: (failure) => emit(QCError(failure.message)),
      ifRight: (results) => emit(QCResultsLoaded(results)),
    );
  }

  // ============================================================
  // ✅ 4) All QC Results
  // ============================================================
  Future<void> loadAllQCResults() async {
    emit(const QCLoading());

    final result = await _qcRepository.getAllQCResults();

    result.fold(
      ifLeft: (failure) => emit(QCError(failure.message)),
      ifRight: (results) => emit(QCResultsLoaded(results)),
    );
  }

  // ============================================================
  // ✅ 5) Dashboard Loader (Trend + Alerts + Recommendations)
  // ============================================================
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

            /// ✅ Today's results
            final todayResults = results.where((r) {
              return r.createdAt.year == now.year &&
                  r.createdAt.month == now.month &&
                  r.createdAt.day == now.day;
            });

            final passedToday = todayResults
                .where((e) => e.result == AppConstants.qcResultPass)
                .length;

            final failedToday = todayResults
                .where((e) => e.result == AppConstants.qcResultFail)
                .length;

            /// ✅ Trend (Last 7 Days)
            final trend = _buildTrend(results);

            /// ✅ Risk Level + Alerts
            final riskLevel = _calculateRiskLevel(passedToday, failedToday);
            final alerts = _generateAlerts(riskLevel);

            /// ✅ Auto Recommendations
            final recommendations = _generateRecommendations(results);

            emit(
              QCDashboardLoaded(
                pendingCount: pendingBatches.length,
                passedToday: passedToday,
                failedToday: failedToday,
                recentResults: results.take(5).toList(),
                trend: trend,
                riskLevel: riskLevel,
                alerts: alerts,
                recommendations: recommendations,
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // ✅ Helpers
  // ============================================================

  /// ✅ Trend last 7 days
  List<QCTrendDayEntity> _buildTrend(List<QCResultEntity> results) {
    final now = DateTime.now();
    final List<QCTrendDayEntity> trend = [];

    for (int i = 6; i >= 0; i--) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));

      final dayResults = results.where((r) {
        final d = r.createdAt;
        return d.year == day.year && d.month == day.month && d.day == day.day;
      });

      final passed = dayResults
          .where((e) => e.result == AppConstants.qcResultPass)
          .length;

      final failed = dayResults
          .where((e) => e.result == AppConstants.qcResultFail)
          .length;

      trend.add(QCTrendDayEntity(day: day, passed: passed, failed: failed));
    }

    return trend;
  }

  /// ✅ Risk Level Based on passRate
  String _calculateRiskLevel(int passedToday, int failedToday) {
    final total = passedToday + failedToday;
    if (total == 0) return "LOW";

    final passRate = (passedToday / total) * 100;

    if (passRate < 60) return "HIGH";
    if (passRate < 80) return "MEDIUM";
    return "LOW";
  }

  /// ✅ Alerts Based on Risk
  List<String> _generateAlerts(String riskLevel) {
    if (riskLevel == "HIGH") {
      return [
        "⚠️ High failure rate detected today!",
        "⚠️ QC should investigate production line immediately.",
      ];
    }

    if (riskLevel == "MEDIUM") {
      return ["⚠️ Moderate risk: monitor batches closely."];
    }

    return ["✅ QC performance is stable today."];
  }

  // ============================================================
  // ✅ Auto Recommendation Engine
  // ============================================================
  List<QCRecommendation> _generateRecommendations(
    List<QCResultEntity> results,
  ) {
    if (results.isEmpty) return [];

    final failed = results
        .where((e) => e.result == AppConstants.qcResultFail)
        .toList();

    /// ✅ إذا مافي Failures
    if (failed.isEmpty) {
      return const [
        QCRecommendation(
          title: "✅ Excellent Quality Performance",
          description:
              "No failures detected today. Keep monitoring key parameters.",
          severity: "low",
          action: "Maintain SOP & continue daily monitoring",
        ),
      ];
    }

    /// ✅ Most frequent failure reason
    final reasons = <String, int>{};
    for (var f in failed) {
      final reason = f.failureReason ?? "Unknown";
      reasons[reason] = (reasons[reason] ?? 0) + 1;
    }

    final topReason = reasons.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    final recs = <QCRecommendation>[
      QCRecommendation(
        title: "⚠️ Most Frequent Failure Detected",
        description: "Top reason: ${topReason.key} (${topReason.value} times)",
        severity: topReason.value >= 3 ? "high" : "medium",
        action: "Review production stage related to: ${topReason.key}",
      ),
    ];

    /// ✅ Moisture analysis
    final highMoisture = results.where((e) => e.moisture > 3.0).length;
    if (highMoisture >= 2) {
      recs.add(
        const QCRecommendation(
          title: "💧 Moisture Risk Alert",
          description: "Moisture exceeded 3% in multiple inspections.",
          severity: "high",
          action: "Check drying stage & packaging sealing integrity.",
        ),
      );
    }

    /// ✅ Temperature analysis
    final highTemp = results.where((e) => e.temperature > 8.0).length;
    if (highTemp >= 2) {
      recs.add(
        const QCRecommendation(
          title: "🌡️ Temperature Issue",
          description: "Temperature exceeded safe range in multiple batches.",
          severity: "high",
          action: "Inspect cooling equipment + verify cold chain.",
        ),
      );
    }

    return recs;
  }
}
