import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_report_entity.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

class QCReportTile extends StatelessWidget {
  final QCReportEntity report;

  const QCReportTile({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.picture_as_pdf, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              report.title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () async {
              final url = Uri.parse(report.pdfUrl);
              await launchUrl(url, mode: LaunchMode.externalApplication);
            },
          ),
        ],
      ),
    );
  }
}
