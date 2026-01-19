import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'reports_pdf_theme.dart';
import 'reports_pdf_sections.dart';
import 'reports_pdf_charts.dart';

class ReportsPdfBuilder {
  // =========================================================
  // MAIN ENTRY POINT (SAFE & ROBUST)
  // =========================================================
  static Future<Uint8List> build({
    required String referenceNumber,
    required String dateRangeLabel,

    // SUMMARY
    required String executiveSummaryAr,
    required String executiveSummaryEn,

    // KPI DATA
    required Map<String, String> kpiValues,

    // CHART DATA
    required Map<String, int> failureReasons,
    required Map<String, double> linePassRates,
  }) async {
    final pdf = pw.Document();

    // ---------------------------------------------------------
    // FONTS
    // ---------------------------------------------------------
    final baseFont = await PdfGoogleFonts.cairoRegular();
    final boldFont = await PdfGoogleFonts.cairoBold();

    final theme = ReportsPdfTheme.theme(baseFont: baseFont, boldFont: boldFont);

    // ---------------------------------------------------------
    // SAFE LOGO LOADING
    // ---------------------------------------------------------
    pw.ImageProvider? logo;

    try {
      logo = await imageFromAssetBundle(
        'assets/images/alwadi_logo.png', // ✅ update if needed
      );
    } catch (e) {
      debugPrint("⚠️ PDF Logo not found, continuing without logo: $e");
      logo = null;
    }

    // =====================================================
    // PAGE 1 — HEADER + EXEC SUMMARY + KPI TABLE
    // =====================================================
    pdf.addPage(
      pw.MultiPage(
        theme: theme,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        footer: _footer,
        build: (_) => [
          ReportsPdfTheme.header(
            logo: logo, // ✅ nullable
            reportTitle: "تقرير مراقبة الجودة",
            referenceNumber: referenceNumber,
          ),
          pw.SizedBox(height: 18),
          ReportsPdfSections.executiveSummary(
            arabicText: executiveSummaryAr,
            englishText: executiveSummaryEn,
          ),
          ReportsPdfSections.kpiTable(
            arabicLabels: const {
              "total": "إجمالي الفحوصات",
              "pass": "نسبة النجاح",
              "failed": "عدد الإخفاقات",
              "risk": "مؤشرات الخطر",
            },
            englishLabels: const {
              "total": "Total Inspections",
              "pass": "Pass Rate",
              "failed": "Failures",
              "risk": "High Risk",
            },
            values: kpiValues,
          ),
        ],
      ),
    );

    // =====================================================
    // PAGE 2 — FAILURE REASONS
    // =====================================================
    if (failureReasons.isNotEmpty) {
      pdf.addPage(
        ReportsPdfCharts.chartPage(
          arabicTitle: "أسباب الإخفاق الأكثر شيوعًا",
          englishTitle: "Top Failure Reasons",
          chart: ReportsPdfCharts.failureReasonsChart(data: failureReasons),
        ),
      );
    }

    // =====================================================
    // PAGE 3 — LINE PASS RATE
    // =====================================================
    if (linePassRates.length >= 2) {
      pdf.addPage(
        ReportsPdfCharts.chartPage(
          arabicTitle: "معدل النجاح حسب خط الإنتاج",
          englishTitle: "Line Pass Rate Overview",
          chart: ReportsPdfCharts.linePassRateChart(data: linePassRates),
        ),
      );
    }

    return pdf.save();
  }

  // =========================================================
  // FOOTER
  // =========================================================
  static pw.Widget _footer(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        "System Generated Report — Confidential",
        style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
      ),
    );
  }
}
