import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/widgets/custom_text_field.dart';
import 'package:alwadi_food/core/utils/validators.dart';

class QuantityField extends StatelessWidget {
  final TextEditingController controller;

  const QuantityField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Quantity *',
      hint: 'Enter quantity',
      controller: controller,
      validator: (v) => Validators.validatePositiveNumber(v, 'Quantity'),
      keyboardType: TextInputType.number,
    );
  }
}
