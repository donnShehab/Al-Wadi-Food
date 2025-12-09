import 'package:equatable/equatable.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final DashboardData data;

  const DashboardLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class DashboardData extends Equatable {
  final int totalBatches;
  final int passedBatches;
  final int failedBatches;
  final int inProgressBatches;
  final int waitingQCBatches;
  final Map<String, int> failureReasons;
  final Map<String, int> productionByLine;

  const DashboardData({
    required this.totalBatches,
    required this.passedBatches,
    required this.failedBatches,
    required this.inProgressBatches,
    required this.waitingQCBatches,
    required this.failureReasons,
    required this.productionByLine,
  });

  @override
  List<Object?> get props => [
    totalBatches,
    passedBatches,
    failedBatches,
    inProgressBatches,
    waitingQCBatches,
    failureReasons,
    productionByLine,
  ];
}
