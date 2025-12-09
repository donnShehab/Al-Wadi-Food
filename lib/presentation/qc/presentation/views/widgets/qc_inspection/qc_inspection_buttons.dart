import 'dart:io';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/presentation/widgets/custom_button.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/data/models/qc_result_model.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/user_repository.dart';
import 'package:alwadi_food/core/errors/failures.dart';
import 'package:dart_either/dart_either.dart';

class QCInspectionButtons extends StatelessWidget {
  final bool passed;
  final Function(bool) onPassedChanged;
  final GlobalKey<FormState> formKey;

  final TextEditingController temperatureController;
  final TextEditingController weightController;
  final TextEditingController colorController;
  final TextEditingController packagingController;
  final TextEditingController moistureController;
  final TextEditingController textureController;
  final TextEditingController tasteTestController;
  final TextEditingController notesController;
  final TextEditingController failureReasonController;

  final List<File> images;
  final String batchId;

  const QCInspectionButtons({
    super.key,
    required this.passed,
    required this.onPassedChanged,
    required this.formKey,
    required this.temperatureController,
    required this.weightController,
    required this.colorController,
    required this.packagingController,
    required this.moistureController,
    required this.textureController,
    required this.tasteTestController,
    required this.notesController,
    required this.failureReasonController,
    required this.images,
    required this.batchId,
  });

  /// تعامل مع الـ Either قبل استخدام user.name
  Future<void> _handleSubmit(BuildContext context, bool passed) async {
    if (!formKey.currentState!.validate() ||
        (!passed && failureReasonController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final userId = getIt<AuthRepository>().getCurrentUserId();
    if (userId == null) return;

    final Either<Failure, UserEntity> userResult = await getIt<UserRepository>()
        .getUserById(userId);

    userResult.fold(
      ifLeft: 
      (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      ifRight: (value) => 
      (user) {
        // الآن يمكننا الوصول إلى user.name بأمان
        final qcResult = QCResultModel(
          inspectionId: DateTime.now().millisecondsSinceEpoch.toString(),
          batchId: batchId,
          inspectorId: user.uid,
          inspectorName: user.name,
          temperature: double.parse(temperatureController.text),
          weight: double.parse(weightController.text),
          color: colorController.text,
          packaging: packagingController.text,
          moisture: double.parse(moistureController.text),
          texture: textureController.text,
          tasteTest: tasteTestController.text.isEmpty
              ? null
              : tasteTestController.text,
          notes: notesController.text,
          images: [], // يمكن تعديلها لاحقًا لإضافة الصور
          result: passed
              ? AppConstants.qcResultPass
              : AppConstants.qcResultFail,
          failureReason: passed ? null : failureReasonController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final newStatus = passed
            ? AppConstants.statusPassed
            : AppConstants.statusFailed;

        context.read<QCCubit>().createQCResult(
          qcResult,
          images,
          batchId,
          newStatus,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Pass Inspection',
          onPressed: () {
            onPassedChanged(true);
            _handleSubmit(context, true);
          },
          backgroundColor: const Color(0xFF4CAF50),
          icon: Icons.check_circle,
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Fail Inspection',
          onPressed: () {
            onPassedChanged(false);
            _handleSubmit(context, false);
          },
          backgroundColor: const Color(0xFFF44336),
          icon: Icons.cancel,
        ),
      ],
    );
  }
}
