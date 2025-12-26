import 'dart:io';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_alert_entity.dart';
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
      if (!passed && (failureReason == null || failureReason.isEmpty)) {
        emit(const QCError('Failure reason is required'));
        return;
      }

      final userId = _authRepository.getCurrentUserId();
      if (userId == null) {
        emit(const QCError('User not authenticated'));
        return;
      }

      final batchEither = await _productionRepository.getBatchById(batchId);

      await batchEither.fold(
        ifLeft: (failure) async {
          emit(QCError(failure));
          return;
        },
        ifRight: (batch) async {
          final lineName = batch.line;

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
                productionLine: lineName,
                inspectorId: user.uid,
                inspectorName: user.name,
                temperature: measurements.temperature,
                weight: measurements.weight,
                color: "",
                packaging: measurements.packaging,
                moisture: measurements.moisture,
                texture: measurements.texture,
                tasteTest: null,
                notes: measurements.notes,
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

              await loadQCDashboard();
            },
          );
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

    final batchesEither = await _productionRepository.getAllBatches();

    pendingEither.fold(
      ifLeft: (failure) => emit(QCError(failure)),
      ifRight: (pendingBatches) {
        resultsEither.fold(
          ifLeft: (failure) => emit(QCError(failure.message)),
          ifRight: (results) {
            batchesEither.fold(
              ifLeft: (failure) => emit(QCError(failure)),
              ifRight: (allBatches) {
                final now = DateTime.now();

                final todayResults = results.where((r) {
                  return r.createdAt.year == now.year &&
                      r.createdAt.month == now.month &&
                      r.createdAt.day == now.day;
                }).toList();

                final passedToday = todayResults
                    .where((e) => e.result == AppConstants.qcResultPass)
                    .length;

                final failedToday = todayResults
                    .where((e) => e.result == AppConstants.qcResultFail)
                    .length;

                final trend = _buildTrend(results);
                final riskLevel = _calculateRiskLevel(passedToday, failedToday);

                /// ✅ Build batchId -> label map
                final Map<String, String> batchMap = {};
                for (final b in allBatches) {
                  batchMap[b.batchId] = "${b.product} • Line ${b.line}";
                }

                /// ✅ Alerts based on failed today
                final todayFailed = todayResults
                    .where((e) => e.result == AppConstants.qcResultFail)
                    .toList();

                final alerts = _generateAlerts(
                  riskLevel: riskLevel,
                  failedTodayResults: todayFailed,
                  batchMap: batchMap,
                );

                /// ✅ Recommendations (Last 7 days)
                final recommendations = _generateRecommendations(
                  results,
                  batchMap,
                );

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
                    allResults: results,
                    allBatches: allBatches, // ✅ المهم جدًا
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // ============================================================
  // ✅ Helpers
  // ============================================================
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

  String _calculateRiskLevel(int passedToday, int failedToday) {
    final total = passedToday + failedToday;
    if (total == 0) return "LOW";

    final passRate = (passedToday / total) * 100;

    if (passRate < 60) return "HIGH";
    if (passRate < 80) return "MEDIUM";
    return "LOW";
  }

  // ============================================================
  // ✅ Alerts Generator
  // ============================================================
  List<QCAlertEntity> _generateAlerts({
    required String riskLevel,
    required List<QCResultEntity> failedTodayResults,
    required Map<String, String> batchMap,
  }) {
    if (failedTodayResults.isEmpty) return const [];

    final alerts = <QCAlertEntity>[];

    for (final fail in failedTodayResults.take(5)) {
      final label = batchMap[fail.batchId];
      if (label == null) continue;

      final reason = fail.failureReason ?? "Unknown Failure Reason";

      alerts.add(
        QCAlertEntity(
          batchId: fail.batchId,
          batchLabel: "$label (Batch ${fail.batchId})",
          reason: reason,
          action: "Inspect stage related to: $reason",
          severity: riskLevel == "HIGH"
              ? "high"
              : riskLevel == "MEDIUM"
              ? "medium"
              : "low",
        ),
      );
    }

    return alerts;
  }

  // ============================================================
  // ✅ Auto Recommendation Engine (GROUP MODE)
  // ============================================================
  List<QCRecommendation> _generateRecommendations(
    List<QCResultEntity> results,
    Map<String, String> batchMap,
  ) {
    if (results.isEmpty) return [];

    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    final lastWeek = results
        .where((r) => r.createdAt.isAfter(sevenDaysAgo))
        .toList();

    final failed = lastWeek
        .where((e) => e.result == AppConstants.qcResultFail)
        .toList();

    if (failed.isEmpty) {
      return const [
        QCRecommendation(
          title: "✅ Excellent Weekly Quality",
          description: "No failures detected in the last 7 days.",
          severity: "low",
          action: "Maintain SOP & continue daily monitoring.",
          type: "general",
        ),
      ];
    }

    final recs = <QCRecommendation>[];

    // ============================================================
    // ✅ 1) Most Frequent Failure Reason (GROUP)
    // ============================================================
    final reasons = <String, int>{};
    for (var f in failed) {
      final reason = f.failureReason ?? "Unknown";
      reasons[reason] = (reasons[reason] ?? 0) + 1;
    }

    final topReason = reasons.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    final affectedByReason = failed
        .where((f) => (f.failureReason ?? "Unknown") == topReason.key)
        .map((e) => e.batchId)
        .toSet()
        .toList();

    recs.add(
      QCRecommendation(
        title: "Most Frequent Failure",
        description:
            "${topReason.key} repeated ${topReason.value} times (7 days).",
        severity: topReason.value >= 4 ? "high" : "medium",
        action: "Review stage related to: ${topReason.key}",
        type: "failure",
        affectedBatches: affectedByReason,
      ),
    );

    // ============================================================
    // ✅ 2) Line Risk (GROUP)
    // ============================================================
    final lineCounts = <String, int>{};
    for (final f in failed) {
      final line = f.productionLine;
      lineCounts[line] = (lineCounts[line] ?? 0) + 1;
    }

    final topLine = lineCounts.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    final affectedByLine = failed
        .where((e) => e.productionLine == topLine.key)
        .map((e) => e.batchId)
        .toSet()
        .toList();

    if (topLine.value >= 2) {
      recs.add(
        QCRecommendation(
          title: "Most Risky Production Line",
          description:
              "Line ${topLine.key} has ${topLine.value} failures this week.",
          severity: topLine.value >= 4 ? "high" : "medium",
          action:
              "Inspect operators + machine settings on Line ${topLine.key}.",
          type: "line_risk",
          affectedBatches: affectedByLine,
        ),
      );
    }

    // ============================================================
    // ✅ 3) Moisture Risk (GROUP)
    // ============================================================
    final highMoisture = lastWeek.where((e) => e.moisture > 3.0).toList();
    final affectedMoisture = highMoisture
        .map((e) => e.batchId)
        .toSet()
        .toList();

    if (highMoisture.length >= 2) {
      recs.add(
        QCRecommendation(
          title: "Moisture Risk Detected",
          description:
              "Moisture exceeded 3% in ${highMoisture.length} inspections.",
          severity: "high",
          action: "Check drying stage + sealing integrity immediately.",
          type: "moisture",
          affectedBatches: affectedMoisture,
        ),
      );
    }

    // ============================================================
    // ✅ 4) Temperature Risk (GROUP)
    // ============================================================
    final highTemp = lastWeek.where((e) => e.temperature > 8.0).toList();
    final affectedTemp = highTemp.map((e) => e.batchId).toSet().toList();

    if (highTemp.length >= 2) {
      recs.add(
        QCRecommendation(
          title: "Temperature Issue Detected",
          description:
              "Temperature exceeded safe range in ${highTemp.length} inspections.",
          severity: "high",
          action: "Inspect cooling system + verify cold chain process.",
          type: "temperature",
          affectedBatches: affectedTemp,
        ),
      );
    }

    // ============================================================
    // ✅ 5) Packaging Trend (GROUP)
    // ============================================================
    final packagingIssues = failed.where((e) {
      return e.packaging.toLowerCase().contains("bad") ||
          e.packaging.toLowerCase().contains("damaged") ||
          e.packaging.toLowerCase().contains("leak");
    }).toList();

    final affectedPack = packagingIssues.map((e) => e.batchId).toSet().toList();

    if (packagingIssues.length >= 2) {
      recs.add(
        QCRecommendation(
          title: "Packaging Issue Trend",
          description:
              "Packaging problems detected in ${packagingIssues.length} failed inspections.",
          severity: "medium",
          action: "Check sealing machine + packaging material quality.",
          type: "packaging",
          affectedBatches: affectedPack,
        ),
      );
    }

    return recs;
  }
}
