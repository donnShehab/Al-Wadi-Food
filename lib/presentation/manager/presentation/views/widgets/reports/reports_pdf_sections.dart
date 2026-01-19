import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'reports_pdf_theme.dart';

class ReportsPdfSections {
  // =========================================================
  // EXECUTIVE SUMMARY
  // =========================================================
  static pw.Widget executiveSummary({
    required String arabicText,
    required String englishText,
  }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 18, bottom: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _sectionTitle("الملخص التنفيذي", "Executive Summary"),
          pw.SizedBox(height: 8),

          pw.Text(
            arabicText,
            textDirection: pw.TextDirection.rtl,
            style: const pw.TextStyle(fontSize: 11, height: 1.5),
          ),

          pw.SizedBox(height: 6),

          pw.Text(
            englishText,
            textDirection: pw.TextDirection.ltr,
            style: pw.TextStyle(
              fontSize: 9,
              height: 1.4,
              color: PdfColors.grey700,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // KPI TABLE (EXECUTIVE SAFE)
  // =========================================================
  static pw.Widget kpiTable({
    required Map<String, String> arabicLabels,
    required Map<String, String> englishLabels,
    required Map<String, String> values,
  }) {
    final rows = arabicLabels.keys.map((key) {
      return [arabicLabels[key]!, englishLabels[key]!, values[key] ?? "-"];
    }).toList();

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 18),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _sectionTitle("مؤشرات الأداء الرئيسية", "Key Performance Indicators"),
          pw.SizedBox(height: 10),

          pw.Table(
            border: pw.TableBorder.all(
              color: ReportsPdfTheme.primaryRed,
              width: 0.6,
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(2),
            },
            children: [
              _tableHeader(["المؤشر", "Indicator", "القيمة"]),
              ...rows.map(_tableRow),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CHART SECTION PLACEHOLDER
  // =========================================================
  static pw.Widget chartSection({
    required String arabicTitle,
    required String englishTitle,
    required pw.Widget chart,
  }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 22),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _sectionTitle(arabicTitle, englishTitle),
          pw.SizedBox(height: 12),
          chart,
        ],
      ),
    );
  }

  // =========================================================
  // HELPERS
  // =========================================================
  static pw.Widget _sectionTitle(String ar, String en) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 4),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: ReportsPdfTheme.primaryRed, width: 1),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            ar,
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
              color: ReportsPdfTheme.primaryRed,
            ),
          ),
          pw.Text(
            en,
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  static pw.TableRow _tableHeader(List<String> cells) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      children: cells.map((c) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            c,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  static pw.TableRow _tableRow(List<String> cells) {
    return pw.TableRow(
      children: cells.map((c) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(6),
          child: pw.Text(
            c,
            style: const pw.TextStyle(fontSize: 9),
            textAlign: pw.TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}
