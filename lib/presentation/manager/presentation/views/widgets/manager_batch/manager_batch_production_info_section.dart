import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:flutter/material.dart';

class ManagerBatchProductionInfoSection extends StatelessWidget {
  final ProductionBatchEntity batch;

  const ManagerBatchProductionInfoSection({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _card(theme, "Production Info", [
      _row("Product", batch.product, Icons.fastfood),
      _row("Quantity", "${batch.quantity} units", Icons.inventory_2),
      _row("Line", batch.line, Icons.factory),
_row(
        "Operator",
        batch.operatorName.isEmpty ? "-" : batch.operatorName,
        Icons.engineering,
      ),
      if (batch.notes.isNotEmpty) _row("Notes", batch.notes, Icons.note_alt),
    ]);
  }

  Widget _row(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(ThemeData theme, String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
