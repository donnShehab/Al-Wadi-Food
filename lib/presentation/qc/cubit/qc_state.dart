import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_alert_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_recommendation_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_trend_day_entity.dart';
import 'package:equatable/equatable.dart';

sealed class QCState extends Equatable {
  const QCState();

  @override
  List<Object?> get props => [];
}

class QCInitial extends QCState {
  const QCInitial();
}

class QCLoading extends QCState {
  const QCLoading();
}

class QCPendingBatchesLoaded extends QCState {
  final List<ProductionBatchEntity> batches;
  const QCPendingBatchesLoaded(this.batches);

  @override
  List<Object?> get props => [batches];
}

class QCResultsLoaded extends QCState {
  final List<QCResultEntity> results;
  const QCResultsLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class QCSuccess extends QCState {
  final String message;
  const QCSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class QCError extends QCState {
  final String message;
  const QCError(this.message);

  @override
  List<Object?> get props => [message];
}

class QCDashboardLoaded extends QCState {
  final int pendingCount;
  final int passedToday;
  final int failedToday;
  final List<QCResultEntity> recentResults;

  final List<QCTrendDayEntity> trend;

  final String riskLevel;

  /// ✅ alerts as entities
  final List<QCAlertEntity> alerts;

  final List<QCRecommendation> recommendations;

  /// ✅ optional all results if needed by analytics
  final List<QCResultEntity> allResults;
    final List<ProductionBatchEntity> allBatches;


  const QCDashboardLoaded( {
    required this.pendingCount,
    required this.passedToday,
    required this.failedToday,
    required this.recentResults,
    required this.trend,
    required this.riskLevel,
    required this.alerts,
    required this.recommendations,
    required this.allResults,
    required this.allBatches,
  });

  int get totalToday => passedToday + failedToday;

  double get passRate => totalToday == 0 ? 0 : (passedToday / totalToday) * 100;

  @override
  List<Object?> get props => [
    pendingCount,
    passedToday,
    failedToday,
    recentResults,
    trend,
    riskLevel,
    alerts,
    recommendations,
    allResults,
    allBatches,
  ];
}
