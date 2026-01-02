abstract class ManagerProductionTodayState {}

class ManagerProductionTodayInitial extends ManagerProductionTodayState {}

class ManagerProductionTodayLoading extends ManagerProductionTodayState {}

class ManagerProductionTodayLoaded extends ManagerProductionTodayState {
  final List<Map<String, dynamic>> items;
  ManagerProductionTodayLoaded(this.items);
}

class ManagerProductionTodayError extends ManagerProductionTodayState {
  final String message;
  ManagerProductionTodayError(this.message);
}
