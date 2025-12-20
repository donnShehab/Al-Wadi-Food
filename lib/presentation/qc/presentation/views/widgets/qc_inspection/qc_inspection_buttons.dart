// import 'dart:io';
// import 'package:alwadi_food/core/constants/app_constants.dart';
// import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
// import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
// import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
// import 'package:alwadi_food/presentation/qc/data/models/qc_result_model.dart';
// import 'package:alwadi_food/presentation/widgets/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class QCInspectionButtons extends StatelessWidget {
//   final bool passed;
//   final ValueChanged<bool> onPassedChanged;
//   final GlobalKey<FormState> formKey;

//   final TextEditingController temperatureController;
//   final TextEditingController weightController;
//   final TextEditingController colorController;
//   final TextEditingController packagingController;
//   final TextEditingController moistureController;
//   final TextEditingController textureController;
//   final TextEditingController tasteTestController;
//   final TextEditingController notesController;
//   final TextEditingController failureReasonController;

//   final List<File> images;
//   final String batchId;

//   const QCInspectionButtons({
//     super.key,
//     required this.passed,
//     required this.onPassedChanged,
//     required this.formKey,
//     required this.temperatureController,
//     required this.weightController,
//     required this.colorController,
//     required this.packagingController,
//     required this.moistureController,
//     required this.textureController,
//     required this.tasteTestController,
//     required this.notesController,
//     required this.failureReasonController,
//     required this.images,
//     required this.batchId,
//   });

//   void _submit(BuildContext context, {required bool passed}) {
//     final authState = context.read<AuthCubit>().state;

//     if (authState is! AuthSuccess) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('User not authenticated, please login again'),
//         ),
//       );
//       return;
//     }

//     // ✅ Validate form
//     final valid = formKey.currentState?.validate() ?? false;
//     if (!valid) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all required fields')),
//       );
//       return;
//     }

//     // ✅ Failure reason required if failed
//     if (!passed && failureReasonController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failure reason is required')),
//       );
//       return;
//     }

//     final user = authState.user;

//     final qcResult = QCResultModel(
//       inspectionId: DateTime.now().millisecondsSinceEpoch.toString(),
//       batchId: batchId,
//       inspectorId: user.uid,
//       inspectorName: user.name,
//       temperature: double.parse(temperatureController.text.trim()),
//       weight: double.parse(weightController.text.trim()),
//       color: colorController.text.trim(),
//       packaging: packagingController.text.trim(),
//       moisture: double.parse(moistureController.text.trim()),
//       texture: textureController.text.trim(),
//       tasteTest: tasteTestController.text.trim().isEmpty
//           ? null
//           : tasteTestController.text.trim(),
//       notes: notesController.text.trim(),
//       images: const [], // سيتم تعبئتها داخل repo بعد الرفع
//       result: passed ? AppConstants.qcResultPass : AppConstants.qcResultFail,
//       failureReason: passed ? null : failureReasonController.text.trim(),
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );

//     final newStatus = passed
//         ? AppConstants.statusPassed
//         : AppConstants.statusFailed;

//     context.read<QCCubit>().createQCResult(
//       qcResult,
//       images,
//       batchId,
//       newStatus,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CustomButton(
//           text: 'Pass Inspection',
//           onPressed: () {
//             onPassedChanged(true);
//             _submit(context, passed: true);
//           },
//           backgroundColor: const Color(0xFF4CAF50),
//           icon: Icons.check_circle,
//         ),
//         const SizedBox(height: 16),
//         CustomButton(
//           text: 'Fail Inspection',
//           onPressed: () {
//             onPassedChanged(false);
//             _submit(context, passed: false);
//           },
//           backgroundColor: const Color(0xFFF44336),
//           icon: Icons.cancel,
//         ),
//       ],
//     );
//   }
// }
