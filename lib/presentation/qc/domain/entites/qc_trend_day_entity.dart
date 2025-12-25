import 'package:equatable/equatable.dart';

class QCTrendDayEntity extends Equatable {
  final DateTime day;
  final int passed;
  final int failed;

  const QCTrendDayEntity({
    required this.day,
    required this.passed,
    required this.failed,
  });

  int get total => passed + failed;

  double get passRate => total == 0 ? 0 : (passed / total) * 100;

  @override
  List<Object?> get props => [day, passed, failed];
}
