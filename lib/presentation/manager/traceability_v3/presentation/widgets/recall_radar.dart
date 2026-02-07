import 'package:flutter/material.dart';

import '../projections/recall_ui_projection.dart';

class RecallRadar extends StatelessWidget {
  final RecallUiProjection projection;
  final String rootNodeId;

  const RecallRadar({super.key, required this.projection, required this.rootNodeId});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: _execCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Impact Radius',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Quick view of impacted nodes from the selected source.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: projection.nodes.map((node) {
              final tint = node.isSource
                  ? const Color(0xFFB00020)
                  : const Color(0xFFFF8F00);
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: tint.withOpacity(0.10),
                  border: Border.all(color: tint.withOpacity(0.18)),
                ),
                child: Text(
                  node.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.78),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _execCardDecoration() {
  return BoxDecoration(
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
  );
}
