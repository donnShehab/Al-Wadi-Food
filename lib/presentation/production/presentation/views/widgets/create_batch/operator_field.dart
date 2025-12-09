import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/widgets/custom_text_field.dart';
import 'package:alwadi_food/core/utils/validators.dart';

class OperatorField extends StatelessWidget {
  final TextEditingController controller;

  const OperatorField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Operator Name *',
      hint: 'Enter operator name',
      controller: controller,
      validator: (v) => Validators.validateRequired(v, 'Operator name'),
    );
  }
}
