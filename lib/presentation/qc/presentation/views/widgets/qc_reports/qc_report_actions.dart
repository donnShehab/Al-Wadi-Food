import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class QCReportActions {
  static Future<void> openPdfExternal(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not open PDF";
    }
  }

  static Future<void> sharePdf(String url) async {
    await Share.share("QC Report PDF: $url");
  }
}
