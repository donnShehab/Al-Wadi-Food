import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/animations/header_fade_slide.dart';
import 'package:alwadi_food/presentation/animations/welcome_slide_in.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/cubit/production_state.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_header.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_welcome_card.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_stats_tiles.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_role_sections.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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

                  // HomeStatsTiles(
                  //   total: totalBatches,
                  //   passed: passedQC,
                  //   issues: issues,
                  // ),
                  BlocBuilder<ProductionCubit, ProductionState>(
                    builder: (context, state) {
                      if (state is ProductionBatchesLoaded) {
                        final batches = state.batches;

                        final total = batches.length;
                        final passed = batches
                            .where((b) => b.status == AppConstants.statusPassed)
                            .length;
                        final issues = batches
                            .where((b) => b.status == AppConstants.statusFailed)
                            .length;

                        return HomeStatsTiles(
                          total: total,
                          passed: passed,
                          issues: issues,
                        );
                      }

                      // Loading or empty
                      return const SizedBox(height: 80);
                    },
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
