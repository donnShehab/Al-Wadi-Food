abstract class WorstLineTodayState {}

class WorstLineTodayInitial extends WorstLineTodayState {}

class WorstLineTodayLoading extends WorstLineTodayState {}

class WorstLineTodayLoaded extends WorstLineTodayState {
  final List<Map<String, dynamic>> items;
  WorstLineTodayLoaded(this.items);
}

class WorstLineTodayError extends WorstLineTodayState {
  final String message;
  WorstLineTodayError(this.message);
}
