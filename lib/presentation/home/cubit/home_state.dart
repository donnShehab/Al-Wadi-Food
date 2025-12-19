
abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeFullyLoaded extends HomeState {
  final int totalBatches;
  final int passedQC;
  final int issues;

  const HomeFullyLoaded({
    required this.totalBatches,
    required this.passedQC,
    required this.issues,
  });
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}
