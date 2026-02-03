import 'package:flutter/material.dart';

/// Executive / Audit-ready exports tab.
/// UI-only refinement: spacing, typography, radius, shadows.
/// Logic preserved: callbacks are unchanged.
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
        _sectionHeader(
          context,
          title: "Exports",
          subtitle: "Generate formal, audit-ready reports with one tap.",
        ),
        const SizedBox(height: 14),

        _exportCard(
          context,
          title: "Export PDF Report",
          subtitle: "Summary, charts and insights in one document.",
          icon: Icons.picture_as_pdf_rounded,
          accent: const Color(0xFFB00020),
          cta: "Generate PDF",
          onTap: onExportPdf,
        ),
        const SizedBox(height: 14),

        _exportCard(
          context,
          title: "Export Excel Sheet",
          subtitle: "Full inspection records for deeper analysis.",
          icon: Icons.table_chart_rounded,
          accent: const Color(0xFF2E8B57),
          cta: "Generate Excel",
          onTap: onExportExcel,
        ),

        const SizedBox(height: 16),

        // Small compliance note (UI-only).
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: scheme.primary.withOpacity(0.06),
            border: Border.all(color: scheme.primary.withOpacity(0.14)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.verified_user_rounded,
                size: 18,
                color: scheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Exports are designed to be shareable with management and compliance teams. Keep approvals and timestamps consistent for audits.",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    final t = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: t.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.2,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: t.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black54,
            height: 1.3,
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
    required Color accent,
    required String cta,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white.withOpacity(0.96),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 26,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Row(
          children: [
            // Accent strip
            Container(
              width: 6,
              height: 56,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.85),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 12),

            // Icon container
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: accent.withOpacity(0.16)),
              ),
              child: Icon(icon, size: 22, color: accent),
            ),
            const SizedBox(width: 12),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface.withOpacity(0.65),
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // CTA pill (still tappable via InkWell wrapping the whole card)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: scheme.primary.withOpacity(0.16)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cta,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: scheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
