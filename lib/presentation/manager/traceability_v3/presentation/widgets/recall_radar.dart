// presentation/widgets/recall_radar.dart

import 'package:flutter/material.dart';

import '../projections/recall_ui_projection.dart';

class RecallRadar extends StatelessWidget {
  final RecallUiProjection projection;

  const RecallRadar({super.key, required this.projection});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Impact Radius',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: projection.nodes.map((node) {
                return Chip(
                  label: Text(node.label),
                  backgroundColor: node.isSource
                      ? Colors.redAccent
                      : Colors.orangeAccent,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
