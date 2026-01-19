import 'package:alwadi_food/presentation/manager/traceability_v2/domain/projections/trace_recall_projection.dart';
import 'package:flutter/material.dart';

class RecallTimeline extends StatelessWidget {
  final RecallUiProjection projection;

  const RecallTimeline({super.key, required this.projection});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildNodeTile(projection.source, isSource: true),
        ...projection.affected.map(_buildNodeTile),
      ],
    );
  }

  Widget _buildNodeTile(RecallUiNode node, {bool isSource = false}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isSource ? Colors.red : Colors.orange,
        child: Text(node.depth.toString()),
      ),
      title: Text(node.label),
      subtitle: Text('${node.typeKey} • ${node.quantity} ${node.unit}'),
    );
  }
}
