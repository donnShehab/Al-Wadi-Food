import 'dart:io';
import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_measurements_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_step_review/qc_decision_panel.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_step_review/qc_step_measurements.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_step_review/qc_step_review.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_step_review/qc_step_summary.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_step_review/qc_stepper_header.dart';
import 'package:flutter/material.dart';

import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/widgets/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QCInspectionViewBody extends StatefulWidget {
  final String batchId;
  final bool isLoading;

  QCInspectionViewBody({
    super.key,
    required this.batchId,
    required this.isLoading,
  });

  @override
  State<QCInspectionViewBody> createState() => _QCInspectionViewBodyState();
}

class _QCInspectionViewBodyState extends State<QCInspectionViewBody> {
  int _currentStep = 0;

  final _formKey = GlobalKey<FormState>();
  final List<File> _images = [];

  bool _passed = true;

  final _failureReasonController = TextEditingController();
  QCMeasurementsEntity? _measurements;

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: widget.isLoading,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🪜 STEPPER
              QCStepperHeader(currentStep: _currentStep),

              const SizedBox(height: 24),

              /// 🧩 STEP CONTENT
              if (_currentStep == 0) QCStepReview(batchId: widget.batchId),

              if (_currentStep == 1)
                QCStepMeasurements(
                  formKey: _formKey,
                  images: _images,
                  onPickImage: (img) => setState(() => _images.add(img)),
                  onMeasurementsChanged: (data) {
                    setState(() {
                      _measurements = data;
                      _currentStep = 2;
                    });
                  },
                ),

              if (_currentStep == 2 && _measurements != null)
                QCStepSummary(measurements: _measurements!, images: _images),

              if (_currentStep == 3)
                QCDecisionPanel(
                  formKey: _formKey,
                  passed: _passed,
                  failureReasonController: _failureReasonController,
                  onDecisionChanged: (v) => setState(() => _passed = v),
                  onSubmit: () {
                    context.read<QCCubit>().createQCResult(
                      measurements: _measurements! ,
                      batchId: widget.batchId,
                      passed: _passed,
                      failureReason: _passed
                          ? null
                          : _failureReasonController.text,
                      images: _images,
                    );
                  },
                ),

              const SizedBox(height: 32),
/// ⏮ ⏭ NAVIGATION
              if (_currentStep != 1)
                Row(
                  children: [
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: _previousStep,
                        child: const Text('Back'),
                      ),
                    const Spacer(),

                    /// Step 2 (Summary)
                    if (_currentStep == 2)
                      ElevatedButton(
                        onPressed: _nextStep,
                        child: const Text('Confirm & Continue'),
                      ),

                    /// Step 0 only
                    if (_currentStep == 0)
                      ElevatedButton(
                        onPressed: _nextStep,
                        child: const Text('Next'),
                      ),
                  ],
                ),

            ],
          ),
        ),
      ),
    );
  }
}
