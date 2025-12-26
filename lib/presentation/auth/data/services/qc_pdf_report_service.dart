import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class QCPdfReportService {
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
  }) async {
    final pdf = pw.Document();

    final dateFormat = DateFormat("dd MMM yyyy");
    final range =
        "${dateFormat.format(weekStart)} → ${dateFormat.format(weekEnd)}";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "$companyName - QC Weekly Report",
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                "Week Range: $range",
                style: const pw.TextStyle(fontSize: 14),
              ),

              pw.Divider(height: 30),

              pw.Text(
                "📊 QC KPI Summary",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Bullet(text: "Total Inspections: $totalInspections"),
              pw.Bullet(text: "Passed: $passed"),
              pw.Bullet(text: "Failed: $failed"),
              pw.Bullet(text: "Risk Level: $riskLevel"),

              pw.Divider(height: 30),

              pw.Text(
                "⚠️ Top Failure Reasons",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              ...topFailures.map((e) => pw.Bullet(text: e)),

              pw.Divider(height: 30),

              pw.Text(
                "✅ Auto Recommendations",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...recommendations.map((e) => pw.Bullet(text: e)),

              pw.Spacer(),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Generated automatically by QC System",
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
