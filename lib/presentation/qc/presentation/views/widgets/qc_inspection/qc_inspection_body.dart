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
  final theme = Theme.of(context);

  // نفس لغة اللوجن: خلفية سينمائية خفيفة
  final bg = BoxDecoration(
    gradient: RadialGradient(
      center: Alignment.topCenter,
      radius: 1.18,
      colors: [
        theme.colorScheme.surface,
        theme.colorScheme.primary.withOpacity(0.035),
      ],
    ),
  );

  return LoadingOverlay(
    isLoading: widget.isLoading,
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: bg,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// 🪜 STEPPER (Executive Surface)
                _ExecutiveSurface(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: QCStepperHeader(currentStep: _currentStep),
                ),

                const SizedBox(height: 16),

                /// 🧩 STEP CONTENT (Animated, premium)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    final slide =
                        Tween<Offset>(
                          begin: const Offset(0, 0.03),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        );

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: slide, child: child),
                    );
                  },
                  child: _ExecutiveSurface(
                    key: ValueKey<int>(_currentStep),
                    padding: const EdgeInsets.all(18),
                    child: _buildStep(),
                  ),
                ),

                const SizedBox(height: 16),

                /// ⏮ ⏭ NAVIGATION (نفس المنطق تبعك: لا يظهر في Step 1)
                if (_currentStep != 1)
                  _ExecutiveSurface(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        if (_currentStep > 0)
                          TextButton(
                            onPressed: _previousStep,
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                              textStyle: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('Back'),
                          ),

                        const Spacer(),

                        /// Step 2 (Summary)
                        if (_currentStep == 2)
                          ElevatedButton(
                            onPressed: _nextStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Confirm & Continue'),
                          ),

                        /// Step 0 only
                        if (_currentStep == 0)
                          ElevatedButton(
                            onPressed: _nextStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Next'),
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// نفس منطقك، بس مفصول كدالة لتسهيل الـ AnimatedSwitcher
Widget _buildStep() {
  if (_currentStep == 0) {
    return QCStepReview(batchId: widget.batchId);
  }

  if (_currentStep == 1) {
    return QCStepMeasurements(
      formKey: _formKey,
      images: _images,
      onPickImage: (img) => setState(() => _images.add(img)),
      onMeasurementsChanged: (data) {
        setState(() {
          _measurements = data;
          _currentStep = 2;
        });
      },
    );
  }

  if (_currentStep == 2 && _measurements != null) {
    return QCStepSummary(measurements: _measurements!, images: _images);
  }

  return QCDecisionPanel(
    formKey: _formKey,
    passed: _passed,
    failureReasonController: _failureReasonController,
    onDecisionChanged: (v) => setState(() => _passed = v),
    onSubmit: () {
      // ✅ IMPORTANT: هذا هو الاستدعاء الصحيح الموجود عندك
      context.read<QCCubit>().createQCResult(
        measurements: _measurements!,
        batchId: widget.batchId,
        passed: _passed,
        failureReason: _passed ? null : _failureReasonController.text,
        images: _images,
      );
    },
  );
}
}

/// =====================
///  Executive Surface
/// =====================
/// UI-only: premium card with soft border + shadow.
/// بدون أي منطق.
class _ExecutiveSurface extends StatelessWidget {
const _ExecutiveSurface({
  super.key,
  required this.child,
  this.padding = const EdgeInsets.all(16),
});

final Widget child;
final EdgeInsets padding;

@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);

  final surface = theme.colorScheme.surface;
  final outline = theme.colorScheme.onSurface.withOpacity(0.06);

  return Container(
    padding: padding,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color.lerp(surface, Colors.white, 0.10) ?? surface, surface],
      ),
      border: Border.all(color: outline, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 26,
          offset: const Offset(0, 14),
        ),
        BoxShadow(
          color: theme.colorScheme.primary.withOpacity(0.05),
          blurRadius: 18,
          offset: const Offset(0, 10),
          spreadRadius: -6,
        ),
      ],
    ),
    child: child,
  );
}
}
