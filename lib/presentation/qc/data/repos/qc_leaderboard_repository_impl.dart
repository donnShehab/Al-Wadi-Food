import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_leaderboard_entry_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_leaderboard_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:dart_either/dart_either.dart';

class QCLeaderboardRepositoryImpl implements QCLeaderboardRepository {
  final QCRepository _qcRepository;

  QCLeaderboardRepositoryImpl(this._qcRepository);

  @override
  Future<Either<String, List<QCLeaderboardEntryEntity>>>
  getWeeklyLeaderboard() async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 7));
    return _buildLeaderboard(start);
  }

  @override
  Future<Either<String, List<QCLeaderboardEntryEntity>>>
  getMonthlyLeaderboard() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return _buildLeaderboard(start);
  }

  Future<Either<String, List<QCLeaderboardEntryEntity>>> _buildLeaderboard(
    DateTime startDate,
  ) async {
    try {
      final resultsEither = await _qcRepository.getAllQCResults();

      return resultsEither.fold(
        ifLeft: (failure) => Left(failure.message),
        ifRight: (results) {
          final filtered = results.where((r) => r.createdAt.isAfter(startDate));

          final Map<String, QCLeaderboardEntryEntity> map = {};

          for (final r in filtered) {
            final id = r.inspectorId;
            final name = r.inspectorName;

            final passed = r.result == AppConstants.qcResultPass ? 1 : 0;
            final failed = r.result == AppConstants.qcResultFail ? 1 : 0;

            if (!map.containsKey(id)) {
              map[id] = QCLeaderboardEntryEntity(
                inspectorId: id,
                inspectorName: name,
                totalInspections: 1,
                passed: passed,
                failed: failed,
              );
            } else {
              final old = map[id]!;
              map[id] = QCLeaderboardEntryEntity(
                inspectorId: id,
                inspectorName: name,
                totalInspections: old.totalInspections + 1,
                passed: old.passed + passed,
                failed: old.failed + failed,
              );
            }
          }

          final list = map.values.toList()
            ..sort((a, b) => b.passRate.compareTo(a.passRate));

          return Right(list);
        },
      );
    } catch (e) {
      return Left("Failed to build leaderboard: $e");
    }
  }
}
