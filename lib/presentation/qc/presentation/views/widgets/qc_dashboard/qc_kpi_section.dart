import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_stat_card.dart';
import 'package:flutter/material.dart';

class QCKPISection extends StatelessWidget {
  final int pendingCount;
  final int passedToday;
  final int failedToday;

  const QCKPISection({
    super.key,
    required this.pendingCount,
    required this.passedToday,
    required this.failedToday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // UI-only header
        Row(
          children: [
            Text(
              'Today',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'QC Status',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.75),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ✅ IMPORTANT FIX:
        // Remove fixed height so cards can breathe and never overflow.
        Row(
          children: [
            Expanded(
              child: QCStatCard(
                title: "Pending",
                value: pendingCount,
                icon: Icons.hourglass_bottom,
                iconColor: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QCStatCard(
                title: "Passed",
                value: passedToday,
                icon: Icons.check_circle,
                iconColor: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QCStatCard(
                title: "Failed",
                value: failedToday,
                icon: Icons.cancel,
                iconColor: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
