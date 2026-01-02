abstract class ManagerKpiListState {}

class ManagerKpiListInitial extends ManagerKpiListState {}

class ManagerKpiListLoading extends ManagerKpiListState {}

class ManagerKpiListLoaded extends ManagerKpiListState {
  final List<Map<String, dynamic>> items;

  ManagerKpiListLoaded(this.items);
}

class ManagerKpiListError extends ManagerKpiListState {
  final String message;

  ManagerKpiListError(this.message);
}
