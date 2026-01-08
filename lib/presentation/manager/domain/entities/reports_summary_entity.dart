class ReportsSummaryEntity {
  final int totalInspections;
  final int passedCount;
  final int failedCount;
  final int highRiskCount;
  final int resolvedCount;

  const ReportsSummaryEntity({
    required this.totalInspections,
    required this.passedCount,
    required this.failedCount,
    required this.highRiskCount,
    required this.resolvedCount,
  });

  /// ✅ Auto calculated Pass Rate
  double get passRate =>
      totalInspections == 0 ? 0.0 : (passedCount / totalInspections) * 100;
}
