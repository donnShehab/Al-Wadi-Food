import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class QCDailySummaryRow {
  final DateTime day;
  final int total;
  final int passed;
  final int failed;
  final String topFailure;

  QCDailySummaryRow({
    required this.day,
    required this.total,
    required this.passed,
    required this.failed,
    required this.topFailure,
  });
}

class QCLeaderboardRow {
  final int rank;
  final String inspector;
  final int total;
  final int passed;
  final int failed;
  final double passRate;

  QCLeaderboardRow({
    required this.rank,
    required this.inspector,
    required this.total,
    required this.passed,
    required this.failed,
    required this.passRate,
  });
}

class QCPdfReportService {
  final DateFormat _date = DateFormat("dd MMM yyyy");
  final DateFormat _dateShort = DateFormat("EEE dd/MM");
  final DateFormat _dateTime = DateFormat("dd MMM yyyy • hh:mm a");

  // ============================================================
  // ✅ Weekly Report
  // ============================================================
  Future<Uint8List> generateWeeklyPdf({
    required String companyName,
    required DateTime weekStart,
    required DateTime weekEnd,
    required int totalInspections,
    required int passed,
    required int failed,
    required String riskLevel,
    required List<String> topFailures,
    required List<String> recommendations,
    required List<QCDailySummaryRow> dailyRows,
    required List<QCLeaderboardRow> leaderboardRows,
    String approvedBy = "QC Manager",
  }) async {
    return _generateReport(
      companyName: companyName,
      reportTitle: "QC Weekly Report",
      rangeText: "${_date.format(weekStart)} → ${_date.format(weekEnd)}",
      totalInspections: totalInspections,
      passed: passed,
      failed: failed,
      riskLevel: riskLevel,
      topFailures: topFailures,
      recommendations: recommendations,
      dailyRows: dailyRows,
      leaderboardRows: leaderboardRows,
      approvedBy: approvedBy,
    );
  }

  // ============================================================
  // ✅ Monthly Report
  // ============================================================
  Future<Uint8List> generateMonthlyPdf({
    required String companyName,
    required DateTime monthStart,
    required DateTime monthEnd,
    required int totalInspections,
    required int passed,
    required int failed,
    required String riskLevel,
    required List<String> topFailures,
    required List<String> recommendations,
    required List<QCDailySummaryRow> dailyRows,
    required List<QCLeaderboardRow> leaderboardRows,
    String approvedBy = "QC Manager",
  }) async {
    return _generateReport(
      companyName: companyName,
      reportTitle: "QC Monthly Report",
      rangeText: "${_date.format(monthStart)} → ${_date.format(monthEnd)}",
      totalInspections: totalInspections,
      passed: passed,
      failed: failed,
      riskLevel: riskLevel,
      topFailures: topFailures,
      recommendations: recommendations,
      dailyRows: dailyRows,
      leaderboardRows: leaderboardRows,
      approvedBy: approvedBy,
    );
  }

  // ============================================================
  // ✅ Main Generator
  // ============================================================
  Future<Uint8List> _generateReport({
    required String companyName,
    required String reportTitle,
    required String rangeText,
    required int totalInspections,
    required int passed,
    required int failed,
    required String riskLevel,
    required List<String> topFailures,
    required List<String> recommendations,
    required List<QCDailySummaryRow> dailyRows,
    required List<QCLeaderboardRow> leaderboardRows,
    required String approvedBy,
  }) async {
    final pdf = pw.Document();

    final passRate = totalInspections == 0
        ? 0
        : (passed / totalInspections) * 100;

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(28),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
          ),
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildHeader(companyName, reportTitle, rangeText),
          pw.SizedBox(height: 18),

          _buildExecutiveSummaryCards(
            total: totalInspections,
            passed: passed,
            failed: failed,
            passRate: passRate.toDouble(),
            riskLevel: riskLevel,
          ),

          pw.SizedBox(height: 18),

          _sectionTitle("Daily Inspection Summary"),
          _buildDailySummaryTable(dailyRows),

          pw.SizedBox(height: 18),

          _sectionTitle("QC Trend Overview"),
          _buildTrendChart(passed: passed, failed: failed),

          pw.SizedBox(height: 18),

          _sectionTitle("Top Failure Reasons"),
          _buildFailureTable(topFailures),

          pw.SizedBox(height: 18),

          _sectionTitle("QC Leaderboard (Top Inspectors)"),
          _buildLeaderboardTable(leaderboardRows),

          pw.SizedBox(height: 18),

          _sectionTitle("Recommendations & Actions"),
          _buildRecommendations(recommendations),

          pw.SizedBox(height: 22),

          _sectionTitle("Approval & Digital Signature"),
          _buildSignatureBox(approvedBy),
        ],
      ),
    );

    return pdf.save();
  }

  // ============================================================
  // ✅ Header
  // ============================================================
  pw.Widget _buildHeader(String company, String title, String rangeText) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        color: PdfColors.blueGrey900,
        borderRadius: pw.BorderRadius.circular(14),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            width: 44,
            height: 44,
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Center(
              child: pw.Text(
                "QC",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueGrey900,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  company,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  "Report Range: $rangeText",
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 10,
                  ),
                ),
                pw.Text(
                  "Generated: ${_dateTime.format(DateTime.now())}",
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ Footer
  // ============================================================
  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 12),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            "Generated automatically by QC Command Center",
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
          pw.Text(
            "Page ${context.pageNumber} / ${context.pagesCount}",
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ✅ Executive Summary Cards
  // ============================================================
  pw.Widget _buildExecutiveSummaryCards({
    required int total,
    required int passed,
    required int failed,gi
    required double passRate,
    required String riskLevel,
  }) {
    pw.Widget card(String title, String value, PdfColor color) {
      return pw.Expanded(
        child: pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: color,
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Text(
                value,
                style: pw.TextStyle(
                  fontSize: 13,
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final riskColor = riskLevel == "HIGH"
        ? PdfColors.red600
        : riskLevel == "MEDIUM"
        ? PdfColors.orange600
        : PdfColors.green600;

    return pw.Row(
      children: [
        card("Total", "$total", PdfColors.blueGrey700),
        pw.SizedBox(width: 8),
        card("Passed", "$passed", PdfColors.green600),
        pw.SizedBox(width: 8),
        card("Failed", "$failed", PdfColors.red600),
        pw.SizedBox(width: 8),
        card("Pass Rate", "${passRate.toStringAsFixed(1)}%", PdfColors.teal600),
        pw.SizedBox(width: 8),
        card("Risk", riskLevel, riskColor),
      ],
    );
  }

  // ============================================================
  // ✅ Section Title
  // ============================================================
  pw.Widget _sectionTitle(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blueGrey900,
        ),
      ),
    );
  }

  // ============================================================
  // ✅ Daily Summary Table (ONLY days with inspections)
  // ============================================================
  pw.Widget _buildDailySummaryTable(List<QCDailySummaryRow> rows) {
    if (rows.isEmpty) {
      return pw.Text("No inspections found in this period.");
    }

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        fontSize: 9,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      cellStyle: const pw.TextStyle(fontSize: 9),
      headers: ["Day", "Total", "Passed", "Failed", "Top Failure"],
      data: rows.map((r) {
        return [
          _dateShort.format(r.day),
          r.total.toString(),
          r.passed.toString(),
          r.failed.toString(),
          r.topFailure,
        ];
      }).toList(),
    );
  }

  // ============================================================
  // ✅ Trend Chart (Simple Bar)
  // ============================================================
  pw.Widget _buildTrendChart({required int passed, required int failed}) {
    final total = passed + failed;
    if (total == 0) return pw.Text("No inspections available.");

    final passedPercent = passed / total;
    final failedPercent = failed / total;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          height: 16,
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(6),
            color: PdfColors.grey300,
          ),
          child: pw.Row(
            children: [
              pw.Expanded(
                flex: (passedPercent * 100).round(),
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.green600,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                ),
              ),
              pw.Expanded(
                flex: (failedPercent * 100).round(),
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.red500,
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          children: [
            _legendItem(PdfColors.green600, "Passed ($passed)"),
            pw.SizedBox(width: 14),
            _legendItem(PdfColors.red500, "Failed ($failed)"),
          ],
        ),
      ],
    );
  }

  pw.Widget _legendItem(PdfColor color, String text) {
    return pw.Row(
      children: [
        pw.Container(width: 10, height: 10, color: color),
        pw.SizedBox(width: 5),
        pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }

  // ============================================================
  // ✅ Failure Table
  // ============================================================
  pw.Widget _buildFailureTable(List<String> reasons) {
    if (reasons.isEmpty) return pw.Text("No failures detected ✅");

    final counts = <String, int>{};
    for (final r in reasons) {
      counts[r] = (counts[r] ?? 0) + 1;
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        fontSize: 9,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      cellStyle: const pw.TextStyle(fontSize: 9),
      headers: ["Failure Reason", "Count"],
      data: sorted.take(8).map((e) => [e.key, e.value.toString()]).toList(),
    );
  }

  // ============================================================
  // ✅ Leaderboard Table
  // ============================================================
  pw.Widget _buildLeaderboardTable(List<QCLeaderboardRow> rows) {
    if (rows.isEmpty) return pw.Text("No inspectors data available.");

    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        fontSize: 9,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      cellStyle: const pw.TextStyle(fontSize: 9),
      headers: ["Rank", "Inspector", "Total", "Passed", "Failed", "Pass Rate"],
      data: rows.take(5).map((r) {
        return [
          "#${r.rank}",
          r.inspector,
          r.total.toString(),
          r.passed.toString(),
          r.failed.toString(),
          "${r.passRate.toStringAsFixed(1)}%",
        ];
      }).toList(),
    );
  }

  // ============================================================
  // ✅ Recommendations
  // ============================================================
  pw.Widget _buildRecommendations(List<String> recs) {
    if (recs.isEmpty) return pw.Text("No recommendations available.");

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: recs.map((r) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Text("• $r", style: const pw.TextStyle(fontSize: 10)),
        );
      }).toList(),
    );
  }

  // ============================================================
  // ✅ Signature Box
  // ============================================================
  pw.Widget _buildSignatureBox(String approvedBy) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "Approved By: $approvedBy",
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            "Date: ${_dateTime.format(DateTime.now())}",
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            "Signature: __________________________",
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }
}
