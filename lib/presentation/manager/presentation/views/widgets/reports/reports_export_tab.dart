import 'package:flutter/material.dart';

class ReportsExportTab extends StatelessWidget {
  final Future<bool> Function() onExportPdf;
  final Future<bool> Function() onExportExcel;

  const ReportsExportTab({
    super.key,
    required this.onExportPdf,
    required this.onExportExcel,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          "Export Reports",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          "Generate official reports for management (PDF/Excel).",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),

        _exportCard(
          context,
          title: "Export PDF (Official Report)",
          subtitle:
              "Includes charts + summary + insights. Best for printing & sharing.",
          icon: Icons.picture_as_pdf_rounded,
          color: scheme.error,
          onTap: () async {
            _snack(context, "Generating PDF...");
            final ok = await onExportPdf();
            _snack(
              context,
              ok ? "✅ PDF exported successfully" : "❌ Failed",
              success: ok,
            );
          },
        ),
        const SizedBox(height: 14),
        _exportCard(
          context,
          title: "Export Excel (Data Sheet)",
          subtitle:
              "Best for analysis & calculations. Contains all inspections table.",
          icon: Icons.table_chart_rounded,
          color: scheme.secondary,
          onTap: () async {
            _snack(context, "Generating Excel...");
            final ok = await onExportExcel();
            _snack(
              context,
              ok ? "✅ Excel exported successfully" : "❌ Failed",
              success: ok,
            );
          },
        ),

        const SizedBox(height: 22),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: scheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: scheme.primary.withOpacity(0.15)),
          ),
          child: Text(
            "💡 Tip: PDF is best for management meetings. Excel is best for QC manager analysis.",
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
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
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Colors.grey.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
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
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }

  void _snack(BuildContext context, String msg, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
