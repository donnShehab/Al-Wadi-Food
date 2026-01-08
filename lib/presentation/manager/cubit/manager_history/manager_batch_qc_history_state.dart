abstract class ManagerBatchQcHistoryState {}

class ManagerBatchQcHistoryInitial extends ManagerBatchQcHistoryState {}

class ManagerBatchQcHistoryLoading extends ManagerBatchQcHistoryState {}

class ManagerBatchQcHistoryLoaded extends ManagerBatchQcHistoryState {
  final List<Map<String, dynamic>> history;
  ManagerBatchQcHistoryLoaded(this.history);
}

class ManagerBatchQcHistoryError extends ManagerBatchQcHistoryState {
  final String message;
  ManagerBatchQcHistoryError(this.message);
}
