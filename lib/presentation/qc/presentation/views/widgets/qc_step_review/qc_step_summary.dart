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

  Widget _row(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
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
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fact_check,
                  size: 22,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Inspection Summary',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            QCRiskBadge(level: risk),
          ],
        ),

        const SizedBox(height: 14),

        // Measurements
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.colorScheme.onSurface.withOpacity(0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              _row(context, 'Temperature', '${measurements.temperature} °C'),
              Divider(
                height: 1,
                color: theme.colorScheme.onSurface.withOpacity(0.06),
              ),
              _row(context, 'Weight', '${measurements.weight} kg'),
              Divider(
                height: 1,
                color: theme.colorScheme.onSurface.withOpacity(0.06),
              ),
              _row(context, 'Moisture', '${measurements.moisture} %'),
              Divider(
                height: 1,
                color: theme.colorScheme.onSurface.withOpacity(0.06),
              ),
              _row(context, 'Packaging', measurements.packaging),
              Divider(
                height: 1,
                color: theme.colorScheme.onSurface.withOpacity(0.06),
              ),
              _row(context, 'Texture', measurements.texture),
              Divider(
                height: 1,
                color: theme.colorScheme.onSurface.withOpacity(0.06),
              ),
              _row(context, 'Notes', measurements.notes),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Images
        Text(
          'Inspection Images',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),

        if (images.isEmpty)
          Text(
            'No evidence images attached.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: images
                .map(
                  (img) => ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      img,
                      width: 92,
                      height: 92,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
