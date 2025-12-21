import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';

class QCDetailsMeasurementsCard extends StatelessWidget {
  final QCResultEntity result;

  const QCDetailsMeasurementsCard({super.key, required this.result});

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Measurements',
            style: Theme.of(context).textTheme.titleMedium?.semiBold,
          ),
          const SizedBox(height: 12),
          _row('Temperature', '${result.temperature} °C'),
          _row('Weight', '${result.weight} kg'),
          _row('Moisture', '${result.moisture} %'),
          _row('Packaging', result.packaging),
          _row('Texture', result.texture),
          _row('Notes', result.notes),
        ],
      ),
    );
  }
}
