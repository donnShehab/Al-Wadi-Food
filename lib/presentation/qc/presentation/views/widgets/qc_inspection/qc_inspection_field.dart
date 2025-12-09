import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/widgets/custom_text_field.dart';
import 'package:alwadi_food/core/utils/validators.dart';
import 'package:alwadi_food/theme.dart';

class QCInspectionFields extends StatelessWidget {
  final bool passed;
  final TextEditingController temperatureController;
  final TextEditingController weightController;
  final TextEditingController colorController;
  final TextEditingController packagingController;
  final TextEditingController moistureController;
  final TextEditingController textureController;
  final TextEditingController tasteTestController;
  final TextEditingController notesController;
  final TextEditingController failureReasonController;

  const QCInspectionFields({
    super.key,
    required this.passed,
    required this.temperatureController,
    required this.weightController,
    required this.colorController,
    required this.packagingController,
    required this.moistureController,
    required this.textureController,
    required this.tasteTestController,
    required this.notesController,
    required this.failureReasonController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: 'Temperature (°C) *',
          controller: temperatureController,
          validator: (v) => Validators.validateNumber(v, 'Temperature'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: 'Weight (kg) *',
          controller: weightController,
          validator: (v) => Validators.validatePositiveNumber(v, 'Weight'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: 'Color *',
          controller: colorController,
          validator: (v) => Validators.validateRequired(v, 'Color'),
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: 'Packaging Condition *',
          controller: packagingController,
          validator: (v) => Validators.validateRequired(v, 'Packaging'),
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: 'Moisture (%) *',
          controller: moistureController,
          validator: (v) => Validators.validateNumber(v, 'Moisture'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: 'Texture *',
          controller: textureController,
          validator: (v) => Validators.validateRequired(v, 'Texture'),
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: 'Taste Test (Optional)',
          controller: tasteTestController,
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: 'Notes *',
          controller: notesController,
          validator: (v) => Validators.validateRequired(v, 'Notes'),
          maxLines: 3,
        ),
        const SizedBox(height: AppSpacing.md),
        if (!passed)
          CustomTextField(
            label: 'Failure Reason *',
            controller: failureReasonController,
            maxLines: 3,
          ),
      ],
    );
  }
}
