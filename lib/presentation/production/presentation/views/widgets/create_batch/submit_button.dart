import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/widgets/custom_button.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Create Batch',
      onPressed: onPressed,
      icon: Icons.add,
    );
  }
}
