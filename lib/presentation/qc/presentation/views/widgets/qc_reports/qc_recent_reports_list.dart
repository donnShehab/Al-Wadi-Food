import 'package:alwadi_food/presentation/qc/domain/entites/qc_report_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/qc_report_pdf_view.dart';
import 'package:flutter/material.dart';

class QCRecentReportsList extends StatelessWidget {
  final List<QCReportEntity> reports;

  const QCRecentReportsList({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (reports.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "No reports generated yet.",
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: reports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final report = reports[index];

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    QCReportPdfView(pdfUrl: report.pdfUrl, title: report.title),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    report.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  color: theme.colorScheme.primary.withOpacity(0.65),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
