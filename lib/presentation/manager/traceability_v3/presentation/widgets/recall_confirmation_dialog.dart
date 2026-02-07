import 'package:flutter/material.dart';

import '../projections/recall_severity_ui.dart';

class RecallConfirmationDialog extends StatelessWidget {
  final int affectedCount;
  final int maxDepth;
  final RecallSeverityUI severity;
  final VoidCallback onConfirm;

  const RecallConfirmationDialog({
    super.key,
    required this.affectedCount,
    required this.maxDepth,
    required this.severity,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: scheme.surface.withOpacity(0.98),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 30,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: severity.color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: severity.color.withOpacity(0.16)),
                  ),
                  child: Icon(severity.icon, color: severity.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Confirm Recall Execution',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: severity.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: severity.color.withOpacity(0.14)),
              ),
              child: Row(
                children: [
                  Text(
                    severity.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: severity.color,
                    ),
                  ),
                  const Spacer(),
                  _pill('Affected: $affectedCount', scheme.onSurface),
                  const SizedBox(width: 8),
                  _pill('Depth: $maxDepth', scheme.onSurface),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Text(
              'This action will BLOCK all affected nodes and create an immutable audit record.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.35,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(color: Colors.black.withOpacity(0.10)),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: severity.color.withOpacity(0.90),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'Confirm & Execute',
                      style: TextStyle(fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _pill(String text, Color tint) {
    final c = tint.withOpacity(0.65);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: c.withOpacity(0.10),
        border: Border.all(color: c.withOpacity(0.16)),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: c),
      ),
    );
  }
}
