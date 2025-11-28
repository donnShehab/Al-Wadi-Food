import 'package:alwadi_food/core/utils/app_colors.dart';
import 'package:alwadi_food/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed; // اجعلها nullable للسماح بتعطيل الزر
//   final Color color;
//   final Widget? icon;

//   const CustomButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     required this.color,
//     this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 54,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: onPressed != null
//             ? color
//             : color.withOpacity(0.5), // أضف opacity عند التعطيل
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: TextButton(
//         onPressed: onPressed, // TextButton يدعم null تلقائيًا
//         style: TextButton.styleFrom(
//           foregroundColor: Colors.white, // لون النص
//           padding: EdgeInsets.zero, // إزالة padding الافتراضي لـ TextButton
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16), // مطابقة borderRadius
//           ),
//         ),
//         child: Row(
//           children: [
//             Text(
//               text,
//               style: TextStyles.bold19.copyWith(color: AppColors.alwadiOrange),
//             ),
//             Spacer(),
//             IconButton(onPressed: onPressed, icon: icon!),
//           ],
//         ),
//       ),
//     );
//   }
// }
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Widget? icon;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.icon,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        color: onPressed != null ? color : color.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Stack(
          children: [
            // النص في المنتصف تمامًا
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyles.bold19.copyWith(color: textColor),
              ),
            ),

            // الأيقونة بأقصى اليمين (مرئية فقط لو non-null)
            if (icon != null)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: icon!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
