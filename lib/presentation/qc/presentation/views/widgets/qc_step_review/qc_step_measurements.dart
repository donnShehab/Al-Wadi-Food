import 'dart:io';

import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_measurements_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_step_review/qc_measurement_fields.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_step_review/qc_measurement_images.dart';

class QCStepMeasurements extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<File> images;
  final ValueChanged<File> onPickImage;
  final ValueChanged<QCMeasurementsEntity> onMeasurementsChanged;

  const QCStepMeasurements({
    super.key,
    required this.formKey,
    required this.images,
    required this.onPickImage,
    required this.onMeasurementsChanged,
  });

  @override
  State<QCStepMeasurements> createState() => _QCStepMeasurementsState();
}

class _QCStepMeasurementsState extends State<QCStepMeasurements> {
  final _temperatureController = TextEditingController();
  final _weightController = TextEditingController();
  final _moistureController = TextEditingController();
  final _textureController = TextEditingController();
  final _packagingController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _temperatureController.dispose();
    _weightController.dispose();
    _moistureController.dispose();
    _textureController.dispose();
    _packagingController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveMeasurements() {
    if (!widget.formKey.currentState!.validate()) return;

    widget.onMeasurementsChanged(
      QCMeasurementsEntity(
        temperature: double.parse(_temperatureController.text),
        weight: double.parse(_weightController.text),
        moisture: double.parse(_moistureController.text),
        texture: _textureController.text,
        packaging: _packagingController.text,
        notes: _notesController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Physical & Quality Measurements',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Record the measured values exactly as observed on the production line.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.78),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 18),

          // Inputs
          _SectionTitle(title: 'Measurements'),
          const SizedBox(height: 10),
          QCMeasurementFields(
            temperatureController: _temperatureController,
            weightController: _weightController,
            moistureController: _moistureController,
            packagingController: _packagingController,
            textureController: _textureController,
            notesController: _notesController,
          ),

          const SizedBox(height: 18),

          // Evidence images
          _SectionTitle(title: 'QC Evidence Images (Optional)'),
          const SizedBox(height: 10),
          QCMeasurementImages(
            images: widget.images,
            onPickImage: widget.onPickImage,
          ),

          const SizedBox(height: 22),

          // Save
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saveMeasurements,
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.check_circle),
              label: const Text('Save & Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.55),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
