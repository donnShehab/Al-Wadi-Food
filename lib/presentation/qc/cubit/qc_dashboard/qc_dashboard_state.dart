import 'package:equatable/equatable.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';

sealed class QCDashboardState extends Equatable {
  const QCDashboardState();

  @override
  List<Object?> get props => [];
}

class QCDashboardInitial extends QCDashboardState {
  const QCDashboardInitial();
}

class QCDashboardLoading extends QCDashboardState {
  const QCDashboardLoading();
}

class QCDashboardLoaded extends QCDashboardState {
  final int pendingCount;
  final int passedToday;
  final int failedToday;
  final List<QCResultEntity> recentResults;

  const QCDashboardLoaded({
    required this.pendingCount,
    required this.passedToday,
    required this.failedToday,
    required this.recentResults,
  });

  @override
  List<Object?> get props => [
    pendingCount,
    passedToday,
    failedToday,
    recentResults,
  ];
}

class QCDashboardError extends QCDashboardState {
  final String message;

  const QCDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
