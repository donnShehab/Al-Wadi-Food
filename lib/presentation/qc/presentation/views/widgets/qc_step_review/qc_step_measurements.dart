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
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          /// 🔢 INPUT FIELDS
       QCMeasurementFields(
            temperatureController: _temperatureController,
            weightController: _weightController,
            moistureController: _moistureController,
            packagingController: _packagingController,
            textureController: _textureController,
            notesController: _notesController,
          ),

          const SizedBox(height: 24),

          /// 🖼 IMAGES
          QCMeasurementImages(
            images: widget.images,
            onPickImage: widget.onPickImage,
          ),

          const SizedBox(height: 32),

          /// 💾 SAVE STEP
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveMeasurements,
              child: const Text('Save & Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
