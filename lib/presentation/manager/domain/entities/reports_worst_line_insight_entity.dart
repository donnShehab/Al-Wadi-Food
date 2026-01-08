class ReportsWorstLineInsightEntity {
  final String lineName;

  final int total;
  final int passed;
  final int failed;
  final int highRisk;

  final double passRate;

  /// ✅ Top failure reasons inside this worst line
  final List<Map<String, dynamic>> topReasons;

  /// [{ "reason": "...", "count": 3 }, ...]

  const ReportsWorstLineInsightEntity({
    required this.lineName,
    required this.total,
    required this.passed,
    required this.failed,
    required this.highRisk,
    required this.passRate,
    required this.topReasons,
  });
}
