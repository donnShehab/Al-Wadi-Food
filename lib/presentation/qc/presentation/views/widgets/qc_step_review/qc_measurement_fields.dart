import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/widgets/custom_text_field.dart';
import 'package:alwadi_food/core/utils/validators.dart';
import 'package:alwadi_food/theme.dart';

class QCMeasurementFields extends StatelessWidget {
  final TextEditingController temperatureController;
  final TextEditingController weightController;
  final TextEditingController moistureController;
  final TextEditingController packagingController;
  final TextEditingController textureController;
  final TextEditingController notesController;

  const QCMeasurementFields({
    super.key,
    required this.temperatureController,
    required this.weightController,
    required this.moistureController,
    required this.packagingController,
    required this.textureController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'Temperature (°C)',
          controller: temperatureController,
          keyboardType: TextInputType.number,
          validator: (v) => Validators.validateNumber(v, 'Temperature'),
        ),
        const SizedBox(height: AppSpacing.md),

        CustomTextField(
          label: 'Weight (kg)',
          controller: weightController,
          keyboardType: TextInputType.number,
          validator: (v) => Validators.validatePositiveNumber(v, 'Weight'),
        ),
        const SizedBox(height: AppSpacing.md),

        CustomTextField(
          label: 'Moisture (%)',
          controller: moistureController,
          keyboardType: TextInputType.number,
          validator: (v) => Validators.validateNumber(v, 'Moisture'),
        ),
        const SizedBox(height: AppSpacing.md),

        CustomTextField(
          label: 'Packaging Condition',
          controller: packagingController,
          validator: (v) => Validators.validateRequired(v, 'Packaging'),
        ),
        const SizedBox(height: AppSpacing.md),

        CustomTextField(
          label: 'Texture',
          controller: textureController,
          validator: (v) => Validators.validateRequired(v, 'Texture'),
        ),
        const SizedBox(height: AppSpacing.md),

        CustomTextField(
          label: 'Notes',
          controller: notesController,
          maxLines: 3,
          validator: (v) => Validators.validateRequired(v, 'Notes'),
        ),
      ],
    );
  }
}
