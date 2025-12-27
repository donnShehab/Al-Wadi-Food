import 'package:alwadi_food/presentation/qc/domain/entites/qc_leaderboard_entry_entity.dart';
import 'package:dart_either/dart_either.dart';

abstract class QCLeaderboardRepository {
  Future<Either<String, List<QCLeaderboardEntryEntity>>> getWeeklyLeaderboard();
  Future<Either<String, List<QCLeaderboardEntryEntity>>>
  getMonthlyLeaderboard();
}
