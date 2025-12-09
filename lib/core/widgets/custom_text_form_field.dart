// // import 'package:e_coomerce_fruit/core/utils/app_text_styles.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';

// // class CustomTextFormField extends StatelessWidget {
// //   const CustomTextFormField({
// //     super.key,
// //     this.initialValue,
// //     required this.hintText,
// //     required this.textInputType,
// //     this.suffixIcon,
// //     this.onSaved,
// //     this.obscureText = false,
// //     this.textDirection,
// //     this.validator,
// //   });
// //   final String? initialValue;
// //   final TextDirection? textDirection;
// //   final String hintText;
// //   final TextInputType textInputType;
// //   final Widget? suffixIcon;
// //   final void Function(String?)? onSaved;
// //   final bool obscureText;
// //   final String ? Function(String?)? validator;
// //   @override
// //   Widget build(BuildContext context) {
// //     return TextFormField(

// //       obscureText: obscureText,
// //       onSaved: onSaved,
// //       validator:
// //           validator ??
// //           (value) {
// //             // استخدم validator المخصص إذا تم تمريره، وإلا استخدم الافتراضي

// //             if (value == null || value.isEmpty) {
// //               return 'هذا الحقل مطلوب';
// //             }

// //             return null;
// //           },
// //       keyboardType: textInputType,
// //       decoration: InputDecoration(
// //         suffixIcon: suffixIcon,
// //         hintStyle: TextStyles.bold13.copyWith(color: const Color(0xFF949D9E)),
// //         hintText: hintText,
// //         filled: true,
// //         fillColor: const Color(0xFFF9FAFA),
// //         border: buildBorder(),
// //         enabledBorder: buildBorder(),
// //         focusedBorder: buildBorder(),
// //       ),
// //     );
// //   }

// //   OutlineInputBorder buildBorder() {
// //     return OutlineInputBorder(
// //       borderRadius: BorderRadius.circular(4),
// //       borderSide: const BorderSide(width: 1, color: Color(0xFFE6E9E9)),
// //     );
// //   }
// // }
// import 'package:alwadi_food/core/utils/app_colors.dart';
// import 'package:alwadi_food/core/utils/app_text_styles.dart';
// import 'package:flutter/material.dart';

// class CustomTextFormField extends StatelessWidget {
//   const CustomTextFormField({
//     super.key,
//     this.initialValue,
//     required this.hintText,
//     required this.textInputType,
//     this.suffixIcon,
//     this.onSaved,
//     this.obscureText = false,
//     this.textDirection,
//     this.validator, this.prefixIcon,
//   });

//   final String? initialValue;
//   final TextDirection? textDirection;
//   final String hintText;
//   final TextInputType textInputType;
//   final Widget? suffixIcon;
//   final void Function(String?)? onSaved;
//   final bool obscureText;
//   final String? Function(String?)? validator;
//   final Widget? prefixIcon;
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
      
//       textDirection: textDirection, // ✅ أهم إضافة
//       obscureText: obscureText,
//       onSaved: onSaved,
//       validator:
//           validator ??
//           (value) {
//             if (value == null || value.isEmpty) {
//               return 'This field is required';
//             }
//             return null;
//           },
          
//       keyboardType: textInputType,
//       style: const TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         prefixIcon: prefixIcon,
//         suffixIcon: suffixIcon,
//         hintStyle: TextStyles.bold13.copyWith(color: Colors.white70),
//         hintText: hintText,
//         filled: true,
//         fillColor: AppColors.transparentWhite,
//         border: buildBorder(),
//         enabledBorder: buildBorder(),
//         focusedBorder: buildFocusedBorder(),
//       ),
//     );
//   }

//   OutlineInputBorder buildBorder() {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(16),
//       borderSide: const BorderSide(width: 1, color: Colors.white54),
//     );
//   }

//   OutlineInputBorder buildFocusedBorder() {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(16),
//       borderSide: const BorderSide(width: 1.5, color: Colors.white),
//     );
//   }
// }
