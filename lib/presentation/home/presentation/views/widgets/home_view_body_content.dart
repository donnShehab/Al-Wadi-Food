import 'package:alwadi_food/presentation/animations/breathing_card.dart';
import 'package:alwadi_food/presentation/animations/fade_slide.dart';
import 'package:alwadi_food/presentation/animations/header_fade_slide.dart';
import 'package:alwadi_food/presentation/animations/soft_highlight_card.dart';
import 'package:alwadi_food/presentation/animations/welcome_slide_in.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_header.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_welcome_card.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_stats_tiles.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_role_sections.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class HomeViewBodyContent extends StatefulWidget {
//   final UserEntity user;
//   final int totalBatches;
//   final int passedQC;
//   final int issues;

//   const HomeViewBodyContent({
//     super.key,
//     required this.user,
//     required this.totalBatches,
//     required this.passedQC,
//     required this.issues,
//   });

//   @override
//   State<HomeViewBodyContent> createState() => _HomeViewBodyContentState();
// }

// class _HomeViewBodyContentState extends State<HomeViewBodyContent>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800), // بطيئة + فخمة
//     );

//     /// مهم جدًا: يبدأ بعد أول frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _controller.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     final mainAnim = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutCubic,
//     );

//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F9FC),
//       body: SafeArea(
//         child: FadeTransition(
//           opacity: mainAnim,
//           child: Transform.scale(
//             scale: Tween<double>(begin: 0.98, end: 1.0).evaluate(mainAnim),
//             child: SingleChildScrollView(
//               padding: AppSpacing.paddingLg,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// HEADER
//                   FadeSlide(
//                     animation: mainAnim,
//                     fromY: 20,
//                     child: HomeHeader(user: widget.user),
//                   ),

//                   const SizedBox(height: 20),

//                   /// WELCOME CARD (🔥 الآن ستراه)
//                  BreathingCard(
//                     child: HomeWelcomeCard(
//                       user: widget.user,
//                       totalBatches: widget.totalBatches,
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   /// STATS
//                   SoftHighlightCard(
//                     animation: mainAnim,
//                     child: HomeStatsTiles(
//                       total: widget.totalBatches,
//                       passed: widget.passedQC,
//                       issues: widget.issues,
//                     ),
//                   ),

//                   const SizedBox(height: 32),

//                   /// ROLE SECTIONS
//                   FadeSlide(
//                     animation: mainAnim,
//                     fromY: 30,
//                     child: HomeRoleSections(
//                       role: widget.user.role,
//                       theme: theme,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class HomeViewBodyContent extends StatelessWidget {
  final UserEntity user;
  final int totalBatches;
  final int passedQC;
  final int issues;

  const HomeViewBodyContent({
    super.key,
    required this.totalBatches,
    required this.passedQC,
    required this.issues,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is! AuthSuccess) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = state.user; // 👈 المصدر الوحيد

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderFadeSlide(child: HomeHeader(user: user)),

                  const SizedBox(height: 20),

                  WelcomeSlideIn(
                    child: HomeWelcomeCard(
                      user: user,
                      totalBatches: totalBatches,
                    ),
                  ),

                  const SizedBox(height: 24),

                  HomeStatsTiles(
                    total: totalBatches,
                    passed: passedQC,
                    issues: issues,
                  ),

                  const SizedBox(height: 32),

                  HomeRoleSections(
                    role: user.role, // ✅ دايمًا أحدث role
                    theme: theme,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
