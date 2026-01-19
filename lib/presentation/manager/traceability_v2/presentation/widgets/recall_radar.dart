import 'package:alwadi_food/presentation/manager/traceability_v2/domain/projections/trace_recall_projection.dart';
import 'package:flutter/material.dart';

class RecallRadar extends StatelessWidget {
  final RecallUiProjection projection;

  const RecallRadar({super.key, required this.projection});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Impact Radius: ${projection.maxDepth}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: projection.affected.map((n) {
            return Chip(
              backgroundColor: n.depth >= 3
                  ? Colors.redAccent
                  : Colors.orangeAccent,
              label: Text('${n.label} (L${n.depth})'),
            );
          }).toList(),
        ),
      ],
    );
  }
}
