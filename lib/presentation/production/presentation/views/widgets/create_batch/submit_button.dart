import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/widgets/custom_button.dart';

class SubmitButtonCreateBatch extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitButtonCreateBatch({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Create Batch',
      onPressed: onPressed,
      icon: Icons.add,
    );
  }
}
