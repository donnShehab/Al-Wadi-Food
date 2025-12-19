import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';

class QCDashboardBody extends StatelessWidget {
  final int pendingCount;
  final int passedToday;
  final int failedToday;

  const QCDashboardBody({
    super.key,
    required this.pendingCount,
    required this.passedToday,
    required this.failedToday,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = (passedToday > failedToday ? passedToday : failedToday)
        .clamp(1, 999);

    return Padding(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Title
          Text(
            'Quality Control Overview',
            style: Theme.of(context).textTheme.headlineSmall?.semiBold,
          ),

          const SizedBox(height: 20),

          /// 🔹 Stats Cards
          Row(
            children: [
              _StatCard(
                title: 'Pending QC',
                value: pendingCount,
                color: Colors.orange,
                icon: Icons.hourglass_bottom,
              ),
              const SizedBox(width: 12),
              _StatCard(
                title: 'Passed Today',
                value: passedToday,
                color: Colors.green,
                icon: Icons.check_circle,
              ),
              const SizedBox(width: 12),
              _StatCard(
                title: 'Failed Today',
                value: failedToday,
                color: Colors.red,
                icon: Icons.cancel,
              ),
            ],
          ),

          const SizedBox(height: 32),

          /// 🔹 TODAY CHART
          Text(
            'Today QC Trend',
            style: Theme.of(context).textTheme.titleMedium?.semiBold,
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _ChartBar(
                  label: 'Passed',
                  value: passedToday,
                  maxValue: maxValue,
                  color: Colors.green,
                ),
                const SizedBox(width: 24),
                _ChartBar(
                  label: 'Failed',
                  value: failedToday,
                  maxValue: maxValue,
                  color: Colors.red,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          /// 🔹 Hint / UX message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Start inspections from "Pending QC" to keep production moving smoothly.',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= STAT CARD =================

class _StatCard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= CHART BAR =================

class _ChartBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color color;

  const _ChartBar({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final heightFactor = value / maxValue;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 140 * heightFactor,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}
