import 'package:alwadi_food/constants.dart';
import 'package:alwadi_food/core/helper_functions/app_router.dart';
import 'package:alwadi_food/core/services/shared_preferences_singleton.dart';
import 'package:alwadi_food/core/utils/app_colors.dart';
import 'package:alwadi_food/core/widgets/custom_button.dart';
import 'package:alwadi_food/feature/on_boarding/presentaion/views/widgets/on_boarding_page_view.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class OnBoardingViewBody extends StatefulWidget {
  const OnBoardingViewBody({super.key});

  @override
  State<OnBoardingViewBody> createState() => _OnBoardingViewBodyState();
}

class _OnBoardingViewBodyState extends State<OnBoardingViewBody> {
  late PageController pageController;
  var currentPage = 0;
  @override
  void initState() {
    pageController = PageController();

    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: OnBoardingPageView(pageController: pageController)),
          DotsIndicator(
            dotsCount: 3,
            position: currentPage.toDouble(),

            decorator: DotsDecorator(
              activeColor: AppColors.alwadiOrange,

              color: currentPage == 2
                  ? AppColors.alwadiOrange
                  : AppColors.alwadiOrange.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 29),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: kVerticalPadding,
              horizontal: kHorizintalPadding,
            ),
            child: Visibility(
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              visible: currentPage == 2 ? true : false,
              child: CustomButton(
                onPressed: () {
                  Prefs.setBool(kIsOnBoardingViewSeen, true);

                  GoRouter.of(context).push(AppRouter.kSigninView);
                },
                color: AppColors.alwadiOrange,
                textColor: AppColors.alwadiWhite,
                text: 'ابدأ الان',
              ),
            ),
          ),
          SizedBox(height: 43),
        ],
      ),
    );
  }
}
