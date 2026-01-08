import 'package:alwadi_food/presentation/manager/domain/entities/reports_summary_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_line_comparison_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_failure_reason_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_worst_line_insight_entity.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/reports/reports_center_firestore_ds.dart';

abstract class ReportsCenterState {}

class ReportsCenterInitial extends ReportsCenterState {}

class ReportsCenterLoading extends ReportsCenterState {}

class ReportsCenterLoaded extends ReportsCenterState {
  final ReportsRange range;
  final ReportsSummaryEntity summary;

  final List<ReportsLineComparisonEntity> linesComparison;
  final ReportsLineComparisonEntity? bestLine;
  final ReportsLineComparisonEntity? worstLine;

  final List<ReportsFailureReasonEntity> topFailureReasons;

  /// ✅ NEW
  final ReportsWorstLineInsightEntity? worstLineInsight;

  ReportsCenterLoaded({
    required this.range,
    required this.summary,
    required this.linesComparison,
    required this.bestLine,
    required this.worstLine,
    required this.topFailureReasons,
    required this.worstLineInsight,
  });
}

class ReportsCenterError extends ReportsCenterState {
  final String message;
  ReportsCenterError(this.message);
}
