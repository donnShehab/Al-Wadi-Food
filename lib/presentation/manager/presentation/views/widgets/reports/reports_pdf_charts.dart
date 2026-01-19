import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'reports_pdf_theme.dart';

class ReportsPdfCharts {
  // =========================================================
  // PAGE WRAPPER (NO SPLITTING)
  // =========================================================
  static pw.Page chartPage({
    required String arabicTitle,
    required String englishTitle,
    required pw.Widget chart,
  }) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (_) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _chartTitle(arabicTitle, englishTitle),
          pw.SizedBox(height: 20),
          chart,
        ],
      ),
    );
  }

  // =========================================================
  // BAR CHART — FAILURE REASONS
  // =========================================================
  static pw.Widget failureReasonsChart({required Map<String, int> data}) {
    return pw.Container(
      height: 300,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: ReportsPdfTheme.primaryRed, width: 0.6),
      ),
      child: pw.CustomPaint(
        painter: (PdfGraphics g, PdfPoint size) {
          if (data.isEmpty) return;

          final maxValue = data.values
              .reduce((a, b) => a > b ? a : b)
              .toDouble();

          final barWidth = size.x / (data.length * 2);
          final scaleY = size.y / maxValue;

          double x = barWidth;

          g.setFillColor(ReportsPdfTheme.primaryRed);

          for (final value in data.values) {
            final barHeight = value * scaleY;

            g.drawRect(x, 0, barWidth, barHeight);
            g.fillPath();

            x += barWidth * 2;
          }
        },
      ),
    );
  }

  // =========================================================
  // LINE CHART — PASS RATE
  // =========================================================
  static pw.Widget linePassRateChart({required Map<String, double> data}) {
    return pw.Container(
      height: 300,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: ReportsPdfTheme.primaryRed, width: 0.6),
      ),
      child: pw.CustomPaint(
        painter: (PdfGraphics g, PdfPoint size) {
          final values = data.values.toList();
          if (values.length < 2) return;

          final maxValue = values.reduce((a, b) => a > b ? a : b);
          final stepX = size.x / (values.length - 1);
          final scaleY = size.y / maxValue;

          g
            ..setStrokeColor(PdfColors.green700)
            ..setLineWidth(2);

          for (int i = 0; i < values.length - 1; i++) {
            final x1 = i * stepX;
            final y1 = values[i] * scaleY;

            final x2 = (i + 1) * stepX;
            final y2 = values[i + 1] * scaleY;

            g
              ..moveTo(x1, y1)
              ..lineTo(x2, y2)
              ..strokePath();
          }
        },
      ),
    );
  }

  // =========================================================
  // TITLES (BILINGUAL / RTL SAFE)
  // =========================================================
  static pw.Widget _chartTitle(String ar, String en) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 6),
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
}
