import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/widgets/custom_text_field.dart';


class CreateBatchField extends StatelessWidget {
  final TextEditingController controller;
  final String textLabel;
  final String hint;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CreateBatchField({
    super.key,
    required this.controller,
    required this.textLabel,
    this.maxLines,
    required this.hint,
    this.keyboardType, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: textLabel,
      hint: hint,
      controller: controller,
      maxLines: maxLines,
    );
  }
}
