// presentation/widgets/recall_node_card.dart

import 'package:alwadi_food/presentation/manager/traceability_v3/presentation/projections/recall_ui_node.dart';
import 'package:flutter/material.dart';

import '../projections/recall_ui_projection.dart';

class RecallNodeCard extends StatelessWidget {
  final RecallUiNode node;

  const RecallNodeCard({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: node.isSource ? Colors.red : Colors.orange,
          child: Text('${node.depth}'),
        ),
        title: Text(node.label),
        subtitle: Text('Type: ${node.type}'),
        trailing: node.isSource ? const Icon(Icons.warning) : null,
      ),
    );
  }
}
