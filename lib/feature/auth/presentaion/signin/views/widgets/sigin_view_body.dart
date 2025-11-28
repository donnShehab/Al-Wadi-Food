import 'dart:io';
import 'dart:ui';

import 'package:alwadi_food/constants.dart';
import 'package:alwadi_food/core/helper_functions/app_router.dart';
import 'package:alwadi_food/core/utils/app_colors.dart';
import 'package:alwadi_food/core/utils/app_images.dart';
import 'package:alwadi_food/core/utils/app_text_styles.dart';
import 'package:alwadi_food/core/widgets/custom_app_bar.dart';
import 'package:alwadi_food/core/widgets/custom_button.dart';
import 'package:alwadi_food/core/widgets/custom_button_social_media.dart';
import 'package:alwadi_food/core/widgets/custom_password_field.dart';
import 'package:alwadi_food/core/widgets/custom_text_form_field.dart';
import 'package:alwadi_food/feature/auth/presentaion/cubits/signin_cubit/signin_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SiginViewBody extends StatefulWidget {
  const SiginViewBody({super.key});

  @override
  State<SiginViewBody> createState() => _SiginViewBodyState();
}

class _SiginViewBodyState extends State<SiginViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(
      //   color: AppColors.alwadiOrange,
      //   context,
      //   title: '',
      //   showNotification: false,
      //   showBackButton: false,
      // ),
      backgroundColor: AppColors.alwadiOrange,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: kVerticalPadding,
            horizontal: kHorizintalPadding,
          ),
          child: Form(
            autovalidateMode: autovalidateMode,
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 24),

                CircleAvatar(
                  maxRadius: 120,
                  child: Image.asset(Assets.imagesLogoAlwadi),
                ),
                CustomTextFormField(
                  onSaved: (value) {
                    email = value!;
                  },
                  prefixIcon: Icon(Icons.email, color: AppColors.alwadiWhite),
                  hintText: 'Enter Email',
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 16),
                CustomPasswordField(
                  prefixIcon: Icon(Icons.lock, color: AppColors.alwadiWhite),
                  hintText: 'Enter Password',
                  onSaved: (value) {
                    password = value!;
                  },
                ),
                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // GoRouter.of(context).push(AppRouter.kForgetPassword);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyles.semiBold13.copyWith(
                          color: AppColors.alwadiWhite,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 33),
                CustomButton(
                  textColor: AppColors.alwadiOrange,
                  icon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.login),
                    color: AppColors.alwadiOrange,
                    iconSize: 26,
                  ),
                  text: 'Login',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      context.read<SigninCubit>().signInWithEmailAndPassword(
                        email,
                        password,
                      );
                    } else {
                      setState(() {
                        autovalidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  color: AppColors.alwadiWhite,
                ),
                SizedBox(height: 33),
                ClickableTextSpan(
                  gestureRecognizer: TapGestureRecognizer()
                    ..onTap = () {
                      GoRouter.of(context).push(AppRouter.kSignupView);
                    },
                  text1: "You Don't a have account?",
                  text2: ' Create account Now',
                ),
                SizedBox(height: 33),
                OrDivider(),
                SizedBox(height: 16),
                CustomButtonSocialMediaa(
                  color: AppColors.alwadiWhite,
                  titleColor: AppColors.alwadiOrange,
                  imageSocial: SvgPicture.asset(Assets.imagesGoogleIcon),
                  title: 'Login By Google',
                  onPressed: () {},
                ),
                SizedBox(height: 12),
                Platform.isIOS
                    ? Column(
                        children: [
                          CustomButtonSocialMediaa(
                            title: 'Login By Apple',
                            imageSocial: SvgPicture.asset(
                              Assets.imagesApplIcon,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(height: 12),
                CustomButtonSocialMediaa(
                  color: AppColors.alwadiWhite,
                  titleColor: AppColors.alwadiOrange,
                  imageSocial: SvgPicture.asset(Assets.imagesFacebookIcon),
                  title: 'Login By Facebook',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ClickableTextSpan extends StatelessWidget {
  final GestureRecognizer gestureRecognizer;
  final String text1;
  final String text2;
  const ClickableTextSpan({
    super.key,
    required this.gestureRecognizer,
    required this.text1,
    required this.text2,
  });
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyles.semiBold13.copyWith(color: Colors.white70),
        children: <TextSpan>[
          TextSpan(text: text1),
          TextSpan(
            text: text2,
            style: TextStyles.bold13.copyWith(color: Colors.white),
            recognizer: gestureRecognizer,
          ),
        ],
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.white54)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('أو', style: TextStyle(color: Colors.white70)),
        ),
        Expanded(child: Divider(color: Colors.white54)),
      ],
    );
  }
}
