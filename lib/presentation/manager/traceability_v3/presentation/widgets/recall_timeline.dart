// presentation/widgets/recall_timeline.dart

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

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        return RecallNodeCard(node: sorted[index]);
      },
    );
  }
}
