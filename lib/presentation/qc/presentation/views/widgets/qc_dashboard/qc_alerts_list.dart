import 'package:flutter/material.dart';

class QCAlertsList extends StatelessWidget {
  final List<String> alerts;

  const QCAlertsList({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "QC Alerts",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        ...alerts.map(
          (alert) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.withOpacity(0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 10, color: Colors.red),
                const SizedBox(width: 10),
                Expanded(child: Text(alert, style: theme.textTheme.bodyMedium)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
