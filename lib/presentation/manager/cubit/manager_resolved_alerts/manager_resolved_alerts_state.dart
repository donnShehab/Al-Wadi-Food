part of 'manager_resolved_alerts_cubit.dart';

abstract class ManagerResolvedAlertsState {}

class ManagerResolvedAlertsInitial extends ManagerResolvedAlertsState {}

class ManagerResolvedAlertsLoading extends ManagerResolvedAlertsState {}

class ManagerResolvedAlertsLoaded extends ManagerResolvedAlertsState {
  final List<Map<String, dynamic>> items;
  ManagerResolvedAlertsLoaded(this.items);
}

class ManagerResolvedAlertsError extends ManagerResolvedAlertsState {
  final String message;
  ManagerResolvedAlertsError(this.message);
}
