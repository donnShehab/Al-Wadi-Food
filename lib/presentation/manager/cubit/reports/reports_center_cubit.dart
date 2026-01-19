import 'package:alwadi_food/presentation/auth/data/services/reports_pdf_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/reports_excel_service.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_line_comparison_entity.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/reports/reports_center_firestore_ds.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'reports_center_state.dart';

class ReportsCenterCubit extends Cubit<ReportsCenterState> {
  final ReportsCenterFirestoreDataSource ds;
  final ReportsPdfService pdfService;
  final ReportsExcelService excelService;

  ReportsCenterCubit(this.ds, this.pdfService, this.excelService)
    : super(ReportsCenterInitial());

  ReportsRange _currentRange = ReportsRange.today;

  Future<void> loadSummary({ReportsRange range = ReportsRange.today}) async {
    emit(ReportsCenterLoading());
    try {
      _currentRange = range;

      final summary = await ds.fetchSummary(range);
      final linesComparison = await ds.fetchLinesComparison(range);

      ReportsLineComparisonEntity? bestLine;
      ReportsLineComparisonEntity? worstLine;

      if (linesComparison.isNotEmpty) {
        bestLine = linesComparison.first;
        worstLine = linesComparison.last;
      }

      final topFailureReasons = await ds.fetchTopFailureReasons(range);
      final worstInsight = await ds.fetchWorstLineInsight(range);

      emit(
        ReportsCenterLoaded(
          range: range,
          summary: summary,
          linesComparison: linesComparison,
          bestLine: bestLine,
          worstLine: worstLine,
          topFailureReasons: topFailureReasons,
          worstLineInsight: worstInsight,
        ),
      );
    } catch (e) {
      emit(ReportsCenterError("Failed to load reports: $e"));
    }
  }

  void changeRange(ReportsRange range) {
    loadSummary(range: range);
  }

  // ============================================================
  // ✅ OLD / STABLE PDF EXPORT (RESTORED)
  // ============================================================
  Future<bool> exportPdf() async {
    if (state is! ReportsCenterLoaded) return false;

    try {
      final loaded = state as ReportsCenterLoaded;

      final inspections = await ds.fetchInspections(loaded.range);

      final file = await pdfService.generateFullReportsPdf(
        range: loaded.range,
        summary: loaded.summary,
        inspections: inspections,
        linesComparison: loaded.linesComparison,
        bestLine: loaded.bestLine,
        worstLine: loaded.worstLine,
        topFailureReasons: loaded.topFailureReasons,
        worstLineInsight: loaded.worstLineInsight,
      );

      await pdfService.openFile(file);
      return true;
    } catch (e) {
      print("❌ PDF export error: $e");
      return false;
    }
  }

  // ============================================================
  // ✅ Excel Export (UNCHANGED)
  // ============================================================
  Future<bool> exportExcel() async {
    if (state is! ReportsCenterLoaded) return false;

    try {
      final loaded = state as ReportsCenterLoaded;
      final inspections = await ds.fetchInspections(loaded.range);

      final file = await excelService.generateSummaryExcel(
        range: loaded.range,
        summary: loaded.summary,
        inspections: inspections,
      );

      return await excelService.openFile(file);
    } catch (e) {
      print("❌ Excel export error: $e");
      return false;
    }
  }
}
