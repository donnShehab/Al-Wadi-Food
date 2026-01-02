abstract class ManagerActionNeededState {}

class ManagerActionNeededInitial extends ManagerActionNeededState {}

class ManagerActionNeededLoading extends ManagerActionNeededState {}

class ManagerActionNeededLoaded extends ManagerActionNeededState {
  final List<Map<String, dynamic>> highRiskAlerts;
  final List<Map<String, dynamic>> pendingBatches;
  final List<Map<String, dynamic>> failedInspections;

  ManagerActionNeededLoaded({
    required this.highRiskAlerts,
    required this.pendingBatches,
    required this.failedInspections,
  });
}

class ManagerActionNeededError extends ManagerActionNeededState {
  final String message;
  ManagerActionNeededError(this.message);
}
