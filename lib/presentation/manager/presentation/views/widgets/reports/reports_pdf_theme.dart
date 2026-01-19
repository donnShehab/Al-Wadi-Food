import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportsPdfTheme {
  // 🔴 Official corporate colors (from report)
  static const PdfColor primaryRed = PdfColor.fromInt(0xFFA30015);
  static const PdfColor accentTeal = PdfColor.fromInt(0xFF2E8B8B);
  static const PdfColor textDark = PdfColors.black;

  static pw.ThemeData theme({
    required pw.Font baseFont,
    required pw.Font boldFont,
  }) {
    return pw.ThemeData.withFont(base: baseFont, bold: boldFont);
  }

  /// ================================
  /// CORPORATE HEADER
  /// ================================
  static pw.Widget header({
    pw.ImageProvider? logo, // ✅ nullable
    required String reportTitle,
    required String referenceNumber,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: primaryRed, width: 1.2)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // LOGO OR FALLBACK
          if (logo != null)
            pw.Image(logo, width: 110, fit: pw.BoxFit.contain)
          else
            pw.Text(
              "AL-WADI",
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: primaryRed,
              ),
            ),

          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  reportTitle,
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: primaryRed,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  "نظام التقارير – مراقبة الجودة",
                  textDirection: pw.TextDirection.rtl,
                  style: pw.TextStyle(fontSize: 9, color: accentTeal),
                ),
              ],
            ),
          ),

          pw.Text(referenceNumber, style: pw.TextStyle(fontSize: 9)),
        ],
      ),
    );
  }

}
