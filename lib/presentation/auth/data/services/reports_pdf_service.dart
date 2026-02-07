import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ FIX Timestamp
import 'package:alwadi_food/presentation/manager/domain/entities/reports_failure_reason_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_line_comparison_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_summary_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_worst_line_insight_entity.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/reports/reports_center_firestore_ds.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportsPdfService {
  Future<File> generateFullReportsPdf({
    required ReportsRange range,
    required ReportsSummaryEntity summary,
    required List<Map<String, dynamic>> inspections,
    required List<ReportsLineComparisonEntity> linesComparison,
    required ReportsLineComparisonEntity? bestLine,
    required ReportsLineComparisonEntity? worstLine,
    required List<ReportsFailureReasonEntity> topFailureReasons,
    required ReportsWorstLineInsightEntity? worstLineInsight,
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();

    final rangeLabel = _rangeLabel(range);

    /// ✅ Prepare chart data
    final failureChartData = topFailureReasons
        .take(6)
        .map((e) => PdfBarData(label: e.reason, value: e.count.toDouble()))
        .toList();

    final linesChartData = linesComparison
        .take(8)
        .map((e) => PdfBarData(label: e.lineName, value: e.passRate))
        .toList();

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return [
            /// ✅ HEADER
            pw.Text(
              "Alwadi Food Factory - QC Reports",
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              "Range: $rangeLabel",
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey800,
              ),
            ),
            pw.Text("Generated at: $now"),
            pw.Divider(height: 26),

            /// ✅ SECTION 1: SUMMARY
            pw.Text(
              "1) Summary",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            _summaryRow(
              "Total Inspections",
              summary.totalInspections.toString(),
            ),
            _summaryRow("Passed", summary.passedCount.toString()),
            _summaryRow("Failed", summary.failedCount.toString()),
            _summaryRow(
              "Pass Rate",
              "${summary.passRate.toStringAsFixed(1)} %",
            ),
            _summaryRow("High Risk Alerts", summary.highRiskCount.toString()),
            _summaryRow("Resolved Alerts", summary.resolvedCount.toString()),
            pw.Divider(height: 28),

            /// ✅ SECTION 2: LINES COMPARISON
            pw.Text(
              "2) Lines Comparison",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            _linesComparisonTable(linesComparison),

            pw.SizedBox(height: 16),

            /// ✅ NEW CHART 1: Lines Pass Rate Chart
            pw.Text(
              "📊 Lines Pass Rate Chart",
              style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            PdfBarChart(
              data: linesChartData,
              height: 160,
              maxValue: 100,
              valueSuffix: "%",
            ),

            pw.SizedBox(height: 12),

            if (bestLine != null && worstLine != null)
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Best/Worst Summary",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      "✅ Best Line: ${bestLine.lineName} (${bestLine.passRate.toStringAsFixed(1)}%)",
                    ),
                    pw.Text(
                      "❌ Worst Line: ${worstLine.lineName} (${worstLine.passRate.toStringAsFixed(1)}%)",
                    ),
                  ],
                ),
              ),

            pw.Divider(height: 28),

            /// ✅ SECTION 3: TOP FAILURE REASONS
            pw.Text(
              "3) Top Failure Reasons",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),

            /// ✅ NEW CHART 2: Top Failures Chart
            pw.Text(
              "📊 Top Failures Chart",
              style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            PdfBarChart(
              data: failureChartData,
              height: 160,
              maxValue: failureChartData.isEmpty
                  ? 0
                  : failureChartData
                        .map((e) => e.value)
                        .reduce((a, b) => a > b ? a : b),
              valueSuffix: "",
            ),

            pw.SizedBox(height: 14),

            /// ✅ table
            _topFailuresTable(topFailureReasons),

            pw.Divider(height: 28),

            /// ✅ SECTION 4: WORST LINE INSIGHT
            pw.Text(
              "4) Worst Line & Why",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            _worstLineInsightCard(worstLineInsight),
            pw.Divider(height: 28),

            /// ✅ SECTION 5: INSPECTIONS TABLE
            pw.Text(
              "5) Inspections Table (Last 50)",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            _inspectionsTable(inspections),

            pw.SizedBox(height: 25),
            pw.Divider(),
            pw.Text(
              "© ${now.year} Alwadi Food Factory - QC System",
              style: const pw.TextStyle(fontSize: 10),
            ),
          ];
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final safeTime =
        "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")}_${now.hour.toString().padLeft(2, "0")}${now.minute.toString().padLeft(2, "0")}";

    final file = File("${dir.path}/QC_Full_Report_${rangeLabel}_$safeTime.pdf");

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // ============================================================
  // ✅ Helpers
  // ============================================================

  pw.Widget _summaryRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(value, style: const pw.TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  pw.Widget _linesComparisonTable(List<ReportsLineComparisonEntity> lines) {
    if (lines.isEmpty) {
      return pw.Text("No line comparison data available.");
    }

    final headers = [
      "Line",
      "Total",
      "Passed",
      "Failed",
      "High Risk",
      "PassRate",
    ];

    final data = lines.map((l) {
      return [
        l.lineName,
        l.total.toString(),
        l.passed.toString(),
        l.failed.toString(),
        l.highRisk.toString(),
        "${l.passRate.toStringAsFixed(1)}%",
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
      cellStyle: const pw.TextStyle(fontSize: 8),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
    );
  }

  pw.Widget _topFailuresTable(List<ReportsFailureReasonEntity> reasons) {
    if (reasons.isEmpty) {
      return pw.Text("No failure reasons found in this range.");
    }

    final headers = ["Reason", "Count"];

    final data = reasons.map((r) => [r.reason, r.count.toString()]).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 9),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1),
      },
    );
  }

  pw.Widget _worstLineInsightCard(ReportsWorstLineInsightEntity? insight) {
    if (insight == null) {
      return pw.Text("No worst line insight available.");
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.red50,
        borderRadius: pw.BorderRadius.circular(12),
        border: pw.Border.all(color: PdfColors.red200),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            "Line: ${insight.lineName}",
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
              color: PdfColors.red800,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text("Total: ${insight.total}"),
          pw.Text("Failed: ${insight.failed}"),
          pw.Text("High Risk: ${insight.highRisk}"),
          pw.Text("Pass Rate: ${insight.passRate.toStringAsFixed(1)}%"),
          pw.SizedBox(height: 10),

          pw.Text(
            "Top Reasons:",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),

          if (insight.topReasons.isEmpty)
            pw.Text("No reasons recorded.")
          else
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: insight.topReasons.map((r) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Text("• ${r["reason"]} (${r["count"]})"),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  pw.Widget _inspectionsTable(List<Map<String, dynamic>> inspections) {
    if (inspections.isEmpty) {
      return pw.Text("No inspections found.");
    }

    final headers = [
      "Product",
      "Line",
      "Temp",
      "Moist",
      "Result",
      "Reason",
      "Date",
    ];

    final data = inspections.map((i) {
      final product = (i["productType"] ?? i["productName"] ?? "-").toString();
      final line = (i["line"] ?? i["productionLine"] ?? "-").toString();
      final temp = (i["temperature"] ?? 0).toString();
      final moist = (i["moisture"] ?? 0).toString();
      final res = (i["result"] ?? "-").toString();
      final reason = (i["failureReason"] ?? "-").toString();

      String dateText = "-";

      final createdAt = i["createdAt"];
      DateTime? dt;

      if (createdAt is Timestamp) {
        dt = createdAt.toDate();
      } else if (createdAt is DateTime) {
        dt = createdAt;
      }

      if (dt != null) {
        dateText =
            "${dt.year}-${dt.month.toString().padLeft(2, "0")}-${dt.day.toString().padLeft(2, "0")} "
            "${dt.hour.toString().padLeft(2, "0")}:${dt.minute.toString().padLeft(2, "0")}";
      }

      return [product, line, temp, moist, res, reason, dateText];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
      cellStyle: const pw.TextStyle(fontSize: 7),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(2.0),
        1: const pw.FlexColumnWidth(1.3),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
        4: const pw.FlexColumnWidth(1),
        5: const pw.FlexColumnWidth(2.0),
        6: const pw.FlexColumnWidth(2.0),
      },
    );
  }

  String _rangeLabel(ReportsRange range) {
    switch (range) {
      case ReportsRange.today:
        return "Today";
      case ReportsRange.week:
        return "Last_7_Days";
      case ReportsRange.month:
        return "Last_Month";
    }
  }

  Future<void> openFile(File file) async {
    // open OpenFilex 
    final result = await OpenFilex.open(file.path);
  }
} 

/// ✅ Data model for PDF Bar Chart
class PdfBarData {
  final String label;
  final double value;
  PdfBarData({required this.label, required this.value});
}

/// ✅ PDF Bar Chart widget (Vector drawn inside PDF)
class PdfBarChart extends pw.StatelessWidget {
  final List<PdfBarData> data;
  final double height;
  final double maxValue;
  final String valueSuffix;

  PdfBarChart({
    required this.data,
    required this.height,
    required this.maxValue,
    required this.valueSuffix,
  });

  @override
  pw.Widget build(pw.Context context) {
    if (data.isEmpty) return pw.Text("No chart data available.");

    return pw.Container(
      height: height,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
        children: data.map((e) {
          final percent = maxValue == 0 ? 0 : (e.value / maxValue);
          final barHeight = (height - 30) * percent;

          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                "${e.value.toStringAsFixed(0)}$valueSuffix",
                style: const pw.TextStyle(fontSize: 7),
              ),
              pw.SizedBox(height: 4),
              pw.Container(
                width: 18,
                height: barHeight,
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue400,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Container(
                width: 45,
                child: pw.Text(
                  e.label.length > 10 ? e.label.substring(0, 10) : e.label,
                  style: const pw.TextStyle(fontSize: 7),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
