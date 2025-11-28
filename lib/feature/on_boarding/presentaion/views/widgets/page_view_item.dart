// import 'package:alwadi_food/core/utils/app_text_styles.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import 'package:go_router/go_router.dart';

// class PageViewItem extends StatelessWidget {
//   const PageViewItem({
//     super.key,
//     required this.backgroundImage,
//     required this.subTitle,
//     required this.title,
//     this.isVisibility = false,
//   });
//   final String backgroundImage;
//   final String subTitle;
//   final Widget title;
//   final bool isVisibility;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           height: MediaQuery.sizeOf(context).height * .3,
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Image.asset(backgroundImage, fit: BoxFit.cover),
//                 ),
//               ),
//               // Positioned(
//               //   bottom: 0,
//               //   left: 0,
//               //   right: 0,
//               //   child: Image.asset(image),
//               // ),
//               Visibility(
//                 visible: isVisibility,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       // GoRouter.of(context).push(AppRouter.kSigninView);
//                       // Prefs.setBool(kIsOnBoardingViewSeen, true);
//                     },
//                     child: Text(
//                       'تخطي',
//                       style: TextStyles.regular13.copyWith(
//                         color: Color(0xFF949D9E),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),

//         title,

//         const SizedBox(height: 20),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Text(
//             subTitle,
//             style: TextStyles.semiBold13.copyWith(color: Color(0xFF4E5556)),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:alwadi_food/constants.dart';
import 'package:alwadi_food/core/helper_functions/app_router.dart';
import 'package:alwadi_food/core/services/shared_preferences_singleton.dart';
import 'package:alwadi_food/core/utils/app_colors.dart';
import 'package:alwadi_food/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/core/utils/app_images.dart';
import 'package:go_router/go_router.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
    this.isVisibility = false,
  });

  final Widget title;
  final String subTitle;
  final String image;
  final bool isVisibility;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,

      children: [
        /// خلفية الشاشة كاملة
        Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),
        Positioned(
          top: 45,
          left: 0,
          right: 0,
          child: Visibility(
            visible: isVisibility,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                                    Prefs.setBool(kIsOnBoardingViewSeen, true);

                  GoRouter.of(context).push(AppRouter.kSigninView);
                  // Prefs.setBool(kIsOnBoardingViewSeen, true);
                },
                child: Text(
                  textDirection: TextDirection.rtl,
                  'تخطي',
                  style: TextStyles.regular16.copyWith(
                    color: AppColors.greyblack,
                  ),
                ),
              ),
            ),
          ),
        ),

        /// المحتوى فوق الخلفية
        Positioned.fill(
          child: Container(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// عنوان الصفحة
                    title,

                    const SizedBox(height: 20),

                    /// النص الوصفي
                    Text(
                      subTitle,
                      style: TextStyles.regular16.copyWith(
                        color: AppColors.greyblack,
                      ),

                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl, // 👈 مهم جداً
                    ),

                    const SizedBox(height: 290),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PageViewItem2 extends StatelessWidget {
  const PageViewItem2({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
    this.isVisibility = false,
  });

  final Widget title;
  final String subTitle;
  final String image;
  final bool isVisibility;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        /// خلفية الشاشة كاملة
        Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),
        Positioned(
          top: 45,
          left: 0,
          right: 0,
          child: Visibility(
            visible: isVisibility,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                                    Prefs.setBool(kIsOnBoardingViewSeen, true);

                  GoRouter.of(context).push(AppRouter.kSigninView);
                  // Prefs.setBool(kIsOnBoardingViewSeen, true);
                },
                child: Text(
                  textDirection: TextDirection.rtl,
                  'تخطي',
                  style: TextStyles.regular16.copyWith(
                    color: AppColors.greyblack,
                  ),
                ),
              ),
            ),
          ),
        ),

        /// المحتوى فوق الخلفية
        Positioned.fill(
          child: Container(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// عنوان الصفحة
                    Center(child: title),

                    const SizedBox(height: 20),

                    /// النص الوصفي
                    Text(
                      subTitle,
                      style: TextStyles.regular16.copyWith(
                        color: AppColors.greyblack,
                      ),

                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl, // 👈 مهم جداً
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PageViewItem3 extends StatelessWidget {
  const PageViewItem3({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
    this.isVisibility = false,
  });

  final Widget title;
  final String subTitle;
  final String image;
  final bool isVisibility;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        /// خلفية الشاشة كاملة
        Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),
        Positioned(
          top: 45,
          left: 0,
          right: 0,
          child: Visibility(
            visible: isVisibility,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Prefs.setBool(kIsOnBoardingViewSeen, true);

                  GoRouter.of(context).push(AppRouter.kSigninView);
                },
                child: Text(
                  textDirection: TextDirection.rtl,
                  'تخطي',
                  style: TextStyles.regular16.copyWith(
                    color: AppColors.greyblack,
                  ),
                ),
              ),
            ),
          ),
        ),

        /// المحتوى فوق الخلفية
        Positioned.fill(
          child: Container(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// عنوان الصفحة
                    Center(child: title),

                    const SizedBox(height: 20),

                    /// النص الوصفي
                    Text(
                      subTitle,
                      style: TextStyles.regular16.copyWith(
                        color: AppColors.greyblack,
                      ),

                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl, // 👈 مهم جداً
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
