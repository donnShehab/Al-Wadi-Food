// ملف: feature/splash/presntation/widgets/splash_view_body.dart

import 'package:alwadi_food/constants.dart';
import 'package:alwadi_food/core/helper_functions/app_router.dart';
import 'package:alwadi_food/core/services/firebase_auth_service.dart';
import 'package:alwadi_food/core/services/shared_preferences_singleton.dart';
import 'package:alwadi_food/core/utils/app_colors.dart';
import 'package:alwadi_food/core/utils/app_images.dart';
import 'package:alwadi_food/core/widgets/slide_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

// إضافة SingleTickerProviderStateMixin لمتابعة حالة حركة اللوجو
class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  // سنستخدم Timer لتأجيل التنقل وليس فقط Future.delayed
  // late Timer _timer;

  @override
  void initState()  {
    super.initState();
    // 1. بدء حركة الزوم مباشرة (ستتم معالجتها في الـ build)

    // 2. ضبط المؤقت لبدء التنقل بعد مدة كافية لانتهاء الحركة

    _navigateBasedOnPrefsAndAuth();
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تحديد الحجم الضخم الذي يغطي الشاشة (مثلاً 50 ضعف الحجم الأصلي)
    const double largeScaleFactor = 2.8;

    return Container(
      color: AppColors.alwadiOrange,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. اللوجو المتحرك: التكبير القوي حتى يغطي الشاشة
          Center(
            child: FadeScaleAnimationWidget(
              duration: const Duration(
                milliseconds: 1800,
              ), // ستكتمل الحركة في 1.8 ثانية
              scaleStart: 1.0, // يبدأ من حجمه الطبيعي
              scaleEnd: largeScaleFactor, // ينتهي بحجم يغطي الشاشة
              curve: Curves.easeInOutCubic, // حركة سلسة ومناسبة للانتقالات
              child: Image.asset(
                Assets.imagesLogoAlwadi,
                height: 180, // اللوجو في حالته الطبيعية
                width: 180,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // منطق التنقل
  void _navigateBasedOnPrefsAndAuth() {
    bool isOnBoardingViewSeen = Prefs.getBool(kIsOnBoardingViewSeen);
    Future.delayed(Duration(seconds: 3), () {
      // if (isOnBoardingViewSeen) {
      //   // var isLoggedIn = FirebaseAuthService().isLoggedIn();
      //   // if (isLoggedIn) {
      //   //   GoRouter.of(context).go(AppRouter.kHomeView);
      //   // }
      //   // else
      //   // {
      //   //   GoRouter.of(context).push(AppRouter.kSigninView);
      //   // }
      // } else {
        GoRouter.of(context).push(AppRouter.kOnboarding);
      // }
    });
  }
}
