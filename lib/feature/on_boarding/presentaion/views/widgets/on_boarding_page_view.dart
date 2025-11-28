import 'package:alwadi_food/core/utils/app_colors.dart';
import 'package:alwadi_food/core/utils/app_images.dart';
import 'package:alwadi_food/core/utils/app_text_styles.dart';
import 'package:alwadi_food/feature/on_boarding/presentaion/views/widgets/page_view_item.dart';
import 'package:flutter/material.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        PageViewItem(
          isVisibility: true,
          image: Assets.imagesOnBoardingWelcomeAlwadi,

          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Welcome to ",
                  style: TextStyles.bold28.copyWith(color: Colors.black87),
                ),
                TextSpan(
                  text: "AlWadi",
                  style: TextStyles.bold28.copyWith(color: AppColors.alwadiRed),
                ),
                TextSpan(
                  text: " Food",
                  style: TextStyles.bold28.copyWith(color: AppColors.alwadiRed),
                ),
              ],
            ),

            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
          subTitle: 'الوادي يعتني بغذائك',
        ),
        PageViewItem2(
          isVisibility: true,
          image: Assets.imagesOnBoardingPageTwo,

          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Taste the Quality, Explore the Variety",
                  style: TextStyles.bold28.copyWith(color: AppColors.alwadiRed),
                ),
              ],
            ),

            textDirection: TextDirection.ltr,
          ),
          subTitle:
              'الوادي يُقدّم لك مجموعة كاملة من المنتجات المجمدة ذات الجودة العالية لإثراء مائدتك بكل سهولة.',
        ),
        PageViewItem3(
          isVisibility: false,
          image: Assets.imagesOnBoardingPageThree,

          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Your Favorites, Delivered to Your Door",
                  style: TextStyles.bold28.copyWith(color: AppColors.alwadiRed),
                ),
              ],
            ),

            textDirection: TextDirection.ltr,
          ),
          subTitle:
              'نضمن لك وصول طلباتك بأقصى سرعة وفي أفضل حالة، لتستمتع بجودة الوادي دون أي عناء.',
        ),
      ],
    );
  }
}
