import 'package:equatable/equatable.dart';

abstract class ManagerActionNeededState extends Equatable {
  const ManagerActionNeededState();

  @override
  List<Object?> get props => [];
}

class ManagerActionNeededInitial extends ManagerActionNeededState {}

class ManagerActionNeededLoading extends ManagerActionNeededState {}

class ManagerActionNeededError extends ManagerActionNeededState {
  final String message;
  const ManagerActionNeededError(this.message);

  @override
  List<Object?> get props => [message];
}

class ManagerActionNeededLoaded extends ManagerActionNeededState {
  final DateTime lastUpdated;

  final List<Map<String, dynamic>> pendingBatches;
  final List<Map<String, dynamic>> failedInspections;
  final List<Map<String, dynamic>> approvedBatches;
  final List<Map<String, dynamic>> blockedBatches;
  final List<Map<String, dynamic>> highRiskAlerts;

  const ManagerActionNeededLoaded({
    required this.lastUpdated,
    required this.pendingBatches,
    required this.failedInspections,
    required this.approvedBatches,
    required this.blockedBatches,
    required this.highRiskAlerts,
  });

  int get pendingCount => pendingBatches.length;
  int get failedCount => failedInspections.length;
  int get approvedCount => approvedBatches.length;
  int get archivedCount => blockedBatches.length;
  int get highRiskCount => highRiskAlerts.length;

  @override
  List<Object?> get props => [
    lastUpdated,
    pendingBatches,
    failedInspections,
    approvedBatches,
    blockedBatches,
    highRiskAlerts,
  ];
}
