import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/widgets/custom_text_field.dart';
import 'package:alwadi_food/core/utils/validators.dart';
import 'package:alwadi_food/theme.dart';

class QCInspectionFormSection extends StatelessWidget {
  final TextEditingController temperatureController;
  final TextEditingController weightController;
  final TextEditingController moistureController;

  final TextEditingController colorController;
  final TextEditingController packagingController;
  final TextEditingController textureController;
  final TextEditingController tasteTestController;

  final TextEditingController notesController;
  final bool passed;

  const QCInspectionFormSection({
    super.key,
    required this.temperatureController,
    required this.weightController,
    required this.moistureController,
    required this.colorController,
    required this.packagingController,
    required this.textureController,
    required this.tasteTestController,
    required this.notesController,
    required this.passed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        /// ===============================
        /// 🧪 Physical Checks
        /// ===============================
        _sectionCard(
          theme,
          title: 'Physical Checks',
          icon: Icons.science,
          children: [
            CustomTextField(
              label: 'Temperature (°C) *',
              controller: temperatureController,
              keyboardType: TextInputType.number,
              validator: (v) => Validators.validateNumber(v, 'Temperature'),
            ),
            const SizedBox(height: AppSpacing.md),
            CustomTextField(
              label: 'Weight (kg) *',
              controller: weightController,
              keyboardType: TextInputType.number,
              validator: (v) => Validators.validatePositiveNumber(v, 'Weight'),
            ),
            const SizedBox(height: AppSpacing.md),
            CustomTextField(
              label: 'Moisture (%) *',
              controller: moistureController,
              keyboardType: TextInputType.number,
              validator: (v) => Validators.validateNumber(v, 'Moisture'),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        /// ===============================
        /// 👁 Visual & Sensory Checks
        /// ===============================
        _sectionCard(
          theme,
          title: 'Visual & Sensory Checks',
          icon: Icons.visibility,
          children: [
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
              label: 'Texture *',
              controller: textureController,
              validator: (v) => Validators.validateRequired(v, 'Texture'),
            ),
            const SizedBox(height: AppSpacing.md),
            CustomTextField(
              label: 'Taste Test (Optional)',
              controller: tasteTestController,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),

        /// ===============================
        /// 📝 Notes
        /// ===============================
        _sectionCard(
          theme,
          title: 'QC Notes',
          icon: Icons.note_alt_outlined,
          children: [
            CustomTextField(
              label: 'Inspection Notes *',
              controller: notesController,
              maxLines: 3,
              validator: (v) => Validators.validateRequired(v, 'Notes'),
            ),
          ],
        ),
      ],
    );
  }

  /// Reusable section card
  Widget _sectionCard(
    ThemeData theme, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.12)),
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
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
