import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class QCReportPdfView extends StatelessWidget {
  final String pdfUrl;
  final String title;

  const QCReportPdfView({super.key, required this.pdfUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}
