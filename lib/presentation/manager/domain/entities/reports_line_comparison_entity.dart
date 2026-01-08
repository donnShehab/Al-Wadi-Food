class ReportsLineComparisonEntity {
  final String lineName;
  final int total;
  final int passed;
  final int failed;
  final int highRisk;

  const ReportsLineComparisonEntity({
    required this.lineName,
    required this.total,
    required this.passed,
    required this.failed,
    required this.highRisk,
  });

  double get passRate => total == 0 ? 0.0 : (passed / total) * 100;
}
