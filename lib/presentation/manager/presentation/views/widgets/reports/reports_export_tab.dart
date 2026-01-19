
import 'package:flutter/material.dart';

class ReportsExportTab extends StatelessWidget {
  final VoidCallback onExportPdf;
  final VoidCallback onExportExcel;

  const ReportsExportTab({
    super.key,
    required this.onExportPdf,
    required this.onExportExcel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _exportCard(
          context,
          title: "Export PDF Report",
          subtitle: "Summary, charts and insights in one document.",
          icon: Icons.picture_as_pdf_rounded,
          color: Colors.redAccent,
          onTap: onExportPdf,
        ),
        const SizedBox(height: 18),
        _exportCard(
          context,
          title: "Export Excel Sheet",
          subtitle: "Full inspection records for analysis.",
          icon: Icons.table_chart_rounded,
          color: Colors.green,
          onTap: onExportExcel,
        ),
      ],
    );
  }

  Widget _exportCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [scheme.surface, scheme.surface.withOpacity(0.85)],
          ),
          border: Border.all(color: color.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.20),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: color.withOpacity(0.12),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
