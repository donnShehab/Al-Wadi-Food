import 'package:alwadi_food/constants.dart';
import 'package:alwadi_food/core/helper_functions/app_router.dart';
import 'package:alwadi_food/core/helper_functions/build_error_bar.dart';
import 'package:alwadi_food/core/utils/app_colors.dart';
import 'package:alwadi_food/core/utils/app_images.dart';
import 'package:alwadi_food/core/widgets/custom_app_bar.dart';
import 'package:alwadi_food/core/widgets/custom_button.dart';
import 'package:alwadi_food/core/widgets/custom_password_field.dart';
import 'package:alwadi_food/core/widgets/custom_text_form_field.dart';
import 'package:alwadi_food/feature/auth/presentaion/cubits/signup_cubit/signup_cubit.dart';
import 'package:alwadi_food/feature/auth/presentaion/signin/views/widgets/sigin_view_body.dart';
import 'package:alwadi_food/feature/auth/presentaion/signup/views/widget/terms_and_conditions_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SignupViewBody extends StatefulWidget {
  const SignupViewBody({super.key});

  @override
  State<SignupViewBody> createState() => _SignupViewBodyState();
}

class _SignupViewBodyState extends State<SignupViewBody> {
  late bool isTermsAccepted = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email, password, name, phoneNumber;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: AppColors.alwadiOrange,

      appBar: buildAppBar(
        iconBackButton: Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.alwadiWhite,
        ),
        showNotification: false,
        titleColor: AppColors.alwadiWhite,
        context,
        title: 'Create Account',

        color: AppColors.alwadiOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kHorizintalPadding,
          vertical: kVerticalPadding,
        ),
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            children: [
              CircleAvatar(
                maxRadius: 80,
                child: Image.asset(Assets.imagesLogoAlwadi),
              ),
              Gap(5),

              CustomTextFormField(
                onSaved: (value) {
                  name = value!;
                },
                hintText: 'Enter Name',
                textInputType: TextInputType.text,
                prefixIcon: Icon(Icons.person, color: AppColors.alwadiWhite),
              ),
              Gap(18),

              CustomTextFormField(
                prefixIcon: Icon(Icons.email, color: AppColors.alwadiWhite),
                onSaved: (value) {
                  email = value!;
                },
                hintText: 'Enter Email',
                textInputType: TextInputType.emailAddress,
              ),
              Gap(18),

              CustomPasswordField(
                onSaved: (value) {
                  password = value!;
                },
                hintText: 'Enter Password',
                prefixIcon: Icon(Icons.lock, color: AppColors.alwadiWhite),
              ),
              Gap(18),

              CustomTextFormField(
                prefixIcon: Icon(Icons.phone, color: AppColors.alwadiWhite),

                onSaved: (value) {
                  phoneNumber = value!;
                },
                hintText: 'Enter Phone Number',
                textInputType: TextInputType.number,
              ),
              Gap(20),
              TermsAndConditionsWidget(
                onChanged: (value) {
                  isTermsAccepted = value;
                },
              ),
              Gap(40),
              CustomButton(
                textColor: AppColors.alwadiOrange,
                icon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.login),
                  color: AppColors.alwadiOrange,
                  iconSize: 26,
                ),

                text: 'SignUp',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (isTermsAccepted) {
                      context
                          .read<SignupCubit>()
                          .createUserWithEmailAndPassword(
                            email,
                            password,
                            name,
                            phoneNumber,
                          );
                    } else {
                      showBar(context, 'You must agree to the terms and conditions.');
                    }
                  } else {
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
                color: AppColors.alwadiWhite,
              ),

              SizedBox(height: 26),
              Align(
                alignment: Alignment.center,
                child: ClickableTextSpan(
                  gestureRecognizer: TapGestureRecognizer()
                    ..onTap = () {
                      GoRouter.of(context).pop();
                    },
                  text1: 'Do you already have an account?',
                  text2: ' Login',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
