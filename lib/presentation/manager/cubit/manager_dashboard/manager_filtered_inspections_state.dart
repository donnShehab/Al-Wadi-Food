abstract class ManagerFilteredInspectionsState {}

class ManagerFilteredInspectionsInitial
    extends ManagerFilteredInspectionsState {}

class ManagerFilteredInspectionsLoading
    extends ManagerFilteredInspectionsState {}

class ManagerFilteredInspectionsLoaded extends ManagerFilteredInspectionsState {
  final List<Map<String, dynamic>> items;

  ManagerFilteredInspectionsLoaded(this.items);
}

class ManagerFilteredInspectionsError extends ManagerFilteredInspectionsState {
  final String message;

  ManagerFilteredInspectionsError(this.message);
}
