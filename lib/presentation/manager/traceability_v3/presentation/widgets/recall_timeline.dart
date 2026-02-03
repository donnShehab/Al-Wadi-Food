import 'package:flutter/material.dart';

import '../projections/recall_ui_projection.dart';
import 'recall_node_card.dart';

class RecallTimeline extends StatelessWidget {
  final RecallUiProjection projection;

  const RecallTimeline({super.key, required this.projection});

  @override
  Widget build(BuildContext context) {
    final sorted = projection.nodes.toList()
      ..sort((a, b) => a.depth.compareTo(b.depth));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        itemCount: sorted.length,
        itemBuilder: (context, index) {
          return RecallNodeCard(node: sorted[index]);
        },
      ),
    );
  }
}
