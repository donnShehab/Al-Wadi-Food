import 'package:equatable/equatable.dart';

sealed class QCDashboardState extends Equatable {
  const QCDashboardState();

  @override
  List<Object?> get props => [];
}

class QCDashboardInitial extends QCDashboardState {}

class QCDashboardLoading extends QCDashboardState {}

class QCDashboardLoaded extends QCDashboardState {
  final int pendingCount;
  final int passedToday;
  final int failedToday;

  const QCDashboardLoaded({
    required this.pendingCount,
    required this.passedToday,
    required this.failedToday,
  });

  @override
  List<Object?> get props => [pendingCount, passedToday, failedToday];
}

class QCDashboardError extends QCDashboardState {
  final String message;

  const QCDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
