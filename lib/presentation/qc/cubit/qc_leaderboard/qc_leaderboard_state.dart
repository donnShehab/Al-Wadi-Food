import 'package:alwadi_food/presentation/qc/domain/entites/qc_leaderboard_entry_entity.dart';
import 'package:equatable/equatable.dart';

sealed class QCLeaderboardState extends Equatable {
  const QCLeaderboardState();

  @override
  List<Object?> get props => [];
}

class QCLeaderboardInitial extends QCLeaderboardState {
  const QCLeaderboardInitial();
}

class QCLeaderboardLoading extends QCLeaderboardState {
  const QCLeaderboardLoading();
}

class QCLeaderboardLoaded extends QCLeaderboardState {
  final List<QCLeaderboardEntryEntity> entries;

  const QCLeaderboardLoaded(this.entries);

  @override
  List<Object?> get props => [entries];
}

class QCLeaderboardError extends QCLeaderboardState {
  final String message;

  const QCLeaderboardError(this.message);

  @override
  List<Object?> get props => [message];
}
