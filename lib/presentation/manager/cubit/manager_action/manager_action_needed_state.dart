abstract class ManagerActionNeededState {}

class ManagerActionNeededInitial extends ManagerActionNeededState {}

class ManagerActionNeededLoading extends ManagerActionNeededState {}

class ManagerActionNeededLoaded extends ManagerActionNeededState {
  final List<Map<String, dynamic>> highRiskAlerts;
  final List<Map<String, dynamic>> pendingBatches;
  final List<Map<String, dynamic>> failedInspections;
  final DateTime lastUpdated; // ✅ تمت إضافة هذا الحقل

  ManagerActionNeededLoaded({
    required this.highRiskAlerts,
    required this.pendingBatches,
    required this.failedInspections,
    required this.lastUpdated, // ✅ مطلوب هنا
  });

  ManagerActionNeededLoaded copyWith({
    List<Map<String, dynamic>>? highRiskAlerts,
    List<Map<String, dynamic>>? pendingBatches,
    List<Map<String, dynamic>>? failedInspections,
    DateTime? lastUpdated,
  }) {
    return ManagerActionNeededLoaded(
      highRiskAlerts: highRiskAlerts ?? this.highRiskAlerts,
      pendingBatches: pendingBatches ?? this.pendingBatches,
      failedInspections: failedInspections ?? this.failedInspections,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class ManagerActionNeededError extends ManagerActionNeededState {
  final String message;
  ManagerActionNeededError(this.message);
}
