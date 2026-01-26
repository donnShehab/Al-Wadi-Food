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
    return AlertDialog(
      title: Row(
        children: [
          Icon(severity.icon, color: severity.color),
          const SizedBox(width: 8),
          const Text('Confirm Recall Execution'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Affected Nodes', affectedCount.toString()),
          _infoRow('Impact Depth', maxDepth.toString()),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: severity.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(severity.icon, color: severity.color),
                const SizedBox(width: 8),
                Text(
                  severity.label,
                  style: TextStyle(
                    color: severity.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Text(
            'This action will lock all affected trace nodes and cannot be undone.',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: severity.color),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text('Confirm Recall'),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
