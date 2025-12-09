import 'dart:io';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_inspection/qc_inspection_field.dart';
import 'package:flutter/material.dart';
import 'qc_inspection_images.dart';
import 'qc_inspection_buttons.dart';

class QCInspectionForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String batchId;
  final List<File> images;
  final bool passed;
  final Function(File) onPickImage;
  final Function(bool) onPassedChanged;

  const QCInspectionForm({
    super.key,
    required this.formKey,
    required this.batchId,
    required this.images,
    required this.passed,
    required this.onPickImage,
    required this.onPassedChanged,
  });

  @override
  State<QCInspectionForm> createState() => _QCInspectionFormState();
}

class _QCInspectionFormState extends State<QCInspectionForm> {
  final _temperatureController = TextEditingController();
  final _weightController = TextEditingController();
  final _colorController = TextEditingController();
  final _packagingController = TextEditingController();
  final _moistureController = TextEditingController();
  final _textureController = TextEditingController();
  final _tasteTestController = TextEditingController();
  final _notesController = TextEditingController();
  final _failureReasonController = TextEditingController();

  @override
  void dispose() {
    _temperatureController.dispose();
    _weightController.dispose();
    _colorController.dispose();
    _packagingController.dispose();
    _moistureController.dispose();
    _textureController.dispose();
    _tasteTestController.dispose();
    _notesController.dispose();
    _failureReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          QCInspectionFields(
            temperatureController: _temperatureController,
            weightController: _weightController,
            colorController: _colorController,
            packagingController: _packagingController,
            moistureController: _moistureController,
            textureController: _textureController,
            tasteTestController: _tasteTestController,
            notesController: _notesController,
            failureReasonController: _failureReasonController,
            passed: widget.passed,
          ),
          const SizedBox(height: 16),
          QCInspectionImages(
            images: widget.images,
            onPickImage: widget.onPickImage,
          ),
          const SizedBox(height: 32),
          QCInspectionButtons(
            passed: widget.passed,
            onPassedChanged: widget.onPassedChanged,
            formKey: widget.formKey,
            temperatureController: _temperatureController,
            weightController: _weightController,
            colorController: _colorController,
            packagingController: _packagingController,
            moistureController: _moistureController,
            textureController: _textureController,
            tasteTestController: _tasteTestController,
            notesController: _notesController,
            failureReasonController: _failureReasonController,
            images: widget.images,
            batchId: widget.batchId,
          ),
        ],
      ),
    );
  }
}
