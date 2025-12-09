import 'dart:io';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_inspection/qc_inspection_form.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/widgets/loading_overlay.dart';
import 'package:alwadi_food/theme.dart';

class QCInspectionBody extends StatefulWidget {
  final String batchId;
  final bool isLoading;

  const QCInspectionBody({
    super.key,
    required this.batchId,
    required this.isLoading,
  });

  @override
  State<QCInspectionBody> createState() => _QCInspectionBodyState();
}

class _QCInspectionBodyState extends State<QCInspectionBody> {
  final _formKey = GlobalKey<FormState>();
  final List<File> _images = [];
  bool _passed = true;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: widget.isLoading,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: QCInspectionForm(
            formKey: _formKey,
            batchId: widget.batchId,
            images: _images,
            passed: _passed,
            onPickImage: (img) => setState(() => _images.add(img)),
            onPassedChanged: (val) => setState(() => _passed = val),
          ),
        ),
      ),
    );
  }
}
