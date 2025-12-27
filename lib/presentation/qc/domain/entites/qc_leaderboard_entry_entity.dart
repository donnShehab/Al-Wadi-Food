import 'package:equatable/equatable.dart';

class QCLeaderboardEntryEntity extends Equatable {
  final String inspectorId;
  final String inspectorName;
  final int totalInspections;
  final int passed;
  final int failed;

  const QCLeaderboardEntryEntity({
    required this.inspectorId,
    required this.inspectorName,
    required this.totalInspections,
    required this.passed,
    required this.failed,
  });

  double get passRate =>
      totalInspections == 0 ? 0 : (passed / totalInspections) * 100;

  @override
  List<Object?> get props => [
    inspectorId,
    inspectorName,
    totalInspections,
    passed,
    failed,
  ];
}
