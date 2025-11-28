import 'package:alwadi_food/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key,
    this.onSaved,
    this.validator,
    this.hintText,
    this.prefixIcon,
  });
  final String? hintText;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      prefixIcon: widget.prefixIcon,
      obscureText: obscureText,
      onSaved: widget.onSaved,
      suffixIcon: GestureDetector(
        onTap: () {
          obscureText = !obscureText;
          setState(() {});
        },
        child: obscureText
            ? const Icon(Icons.remove_red_eye, color: Color(0xffC9CECF))
            : const Icon(Icons.visibility_off, color: Color(0xffC9CECF)),
      ),
      hintText: widget.hintText ?? 'password',
      textInputType: TextInputType.visiblePassword,
    );
  }
}
