import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/manager/traceability_v3/presentation/projections/recall_ui_node.dart';

class RecallNodeCard extends StatelessWidget {
  final RecallUiNode node;

  const RecallNodeCard({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final accent = node.isSource
        ? const Color(0xFFB00020)
        : const Color(0xFFFF8F00);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withOpacity(0.96),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accent.withOpacity(0.16)),
            ),
            child: Center(
              child: Text(
                '${node.depth}',
                style: TextStyle(fontWeight: FontWeight.w900, color: accent),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  node.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _pill(node.type, scheme.onSurface.withOpacity(0.65)),
                    const SizedBox(width: 8),
                    if (node.isSource) _pill('SOURCE', accent),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.chevron_right_rounded,
            color: scheme.onSurface.withOpacity(0.55),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color tint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: tint.withOpacity(0.10),
        border: Border.all(color: tint.withOpacity(0.16)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 11,
          color: tint,
        ),
      ),
    );
  }
}
