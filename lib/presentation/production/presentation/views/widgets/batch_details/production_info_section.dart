import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/info_row.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';


class ProductionInfoSection extends StatelessWidget {
  final ProductionBatchEntity batch;

  const ProductionInfoSection({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _sectionCard(theme, "Production Info", [
      InfoRow(
        label: "Product",
        value: batch.product,
        icon: Icons.restaurant_menu,
      ),
      InfoRow(
        label: "Quantity",
        value: "${batch.quantity} units",
        icon: Icons.inventory_2,
      ),
      InfoRow(label: "Line", value: batch.line, icon: Icons.factory),
      InfoRow(
        label: "Operator",
        value: batch.operatorName,
        icon: Icons.engineering,
      ),
      if (batch.notes.isNotEmpty)
        InfoRow(
          label: "Notes",
          value: batch.notes,
          icon: Icons.note_alt_outlined,
        ),
    ]);
  }

  Widget _sectionCard(ThemeData theme, String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(   
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
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
