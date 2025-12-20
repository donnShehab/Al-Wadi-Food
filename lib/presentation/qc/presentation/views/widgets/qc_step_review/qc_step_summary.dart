import 'dart:io';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_risk/qc_risk_badge.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_risk/qc_risk_evaluator.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_measurements_entity.dart';

class QCStepSummary extends StatelessWidget {
  final QCMeasurementsEntity measurements;
  final List<File> images;

  const QCStepSummary({
    super.key,
    required this.measurements,
    required this.images,
  });

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
final risk = QCRiskEvaluator.evaluate(measurements);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
     Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.fact_check, size: 22),
                const SizedBox(width: 6),
                Text(
                  'Inspection Summary',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            QCRiskBadge(level: risk),
          ],
        ),


        /// 📊 Measurements Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
            ],
          ),
          child: Column(
            children: [
              _row('Temperature', '${measurements.temperature} °C'),
              _row('Weight', '${measurements.weight} kg'),
              _row('Moisture', '${measurements.moisture} %'),
              _row('Packaging', measurements.packaging),
              _row('Texture', measurements.texture),
              _row('Notes', measurements.notes),
            ],
          ),
        ),

        const SizedBox(height: 24),

        /// 🖼 Images
        if (images.isNotEmpty) ...[
          Text(
            'Inspection Images',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: images
                .map(
                  (img) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      img,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
