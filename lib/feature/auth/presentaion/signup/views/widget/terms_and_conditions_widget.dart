import 'package:alwadi_food/core/utils/app_colors.dart';
import 'package:alwadi_food/core/utils/app_text_styles.dart';
import 'package:alwadi_food/feature/auth/presentaion/signup/views/widget/custom_check_box.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsWidget extends StatefulWidget {
  const TermsAndConditionsWidget({super.key, required this.onChanged});
  // هذا الكود ينشئ ويدجت يحتوي على مربع اختيار للشروط والأحكام

  final ValueChanged<bool>
  onChanged; // هذا المتغير يستخدم لنقل حالة مربع الاختيار
  @override
  State<TermsAndConditionsWidget> createState() =>
      _TermsAndConditionsWidgetState();
}

class _TermsAndConditionsWidgetState extends State<TermsAndConditionsWidget> {
  bool isTermsAccepted = false;
  // هذا المتغير يستخدم لتخزين حالة قبول الشروط والأحكام
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(2, 0),
      child: Row(
        children: [
          // SizedBox(
          //   width:
          //       MediaQuery.sizeOf(context).width -
          //       (kHorizintalPadding * 4) -
          //       50,
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'By creating an account, you agree to',
                    style: TextStyles.semiBold13.copyWith(
                      color: AppColors.alwadiWhite,
                    ),
                  ),

                  TextSpan(
                    text: ' Our Terms and Conditions',
                    style: TextStyles.semiBold13.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16),
          CustomCheckBox(
            // هذا الويدجت يمثل مربع اختيار
            onChecked: (value) {
              isTermsAccepted = value;

              widget.onChanged(value);

              setState(() {});
            },
            isChecked: isTermsAccepted,
          ),

          // ),
        ],
      ),
    );
  }
}
