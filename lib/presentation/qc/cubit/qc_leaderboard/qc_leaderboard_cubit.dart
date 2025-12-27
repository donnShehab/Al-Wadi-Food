import 'package:alwadi_food/presentation/qc/domain/repos/qc_leaderboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'qc_leaderboard_state.dart';

class QCLeaderboardCubit extends Cubit<QCLeaderboardState> {
  final QCLeaderboardRepository _repo;

  QCLeaderboardCubit(this._repo) : super(const QCLeaderboardInitial());

  Future<void> loadWeekly() async {
    emit(const QCLeaderboardLoading());

    final result = await _repo.getWeeklyLeaderboard();
    result.fold(
      ifLeft: (failure) => emit(QCLeaderboardError(failure)),
      ifRight: (entries) => emit(QCLeaderboardLoaded(entries)),
    );
  }

  Future<void> loadMonthly() async {
    emit(const QCLeaderboardLoading());

    final result = await _repo.getMonthlyLeaderboard();
    result.fold(
      ifLeft: (failure) => emit(QCLeaderboardError(failure)),
      ifRight: (entries) => emit(QCLeaderboardLoaded(entries)),
    );
  }
}
