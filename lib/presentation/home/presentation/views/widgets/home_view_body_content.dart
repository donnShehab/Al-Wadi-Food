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
          body: DecoratedBox(
            // UI-only: subtle executive background (matches Auth look & feels premium).
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.25,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.primary.withOpacity(0.035),
                ],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = constraints.maxWidth >= 600
                      ? AppSpacing.xxl
                      : AppSpacing.lg;

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: AppSpacing.lg,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderFadeSlide(child: HomeHeader(user: user)),

                            const SizedBox(height: 18),

                            WelcomeSlideIn(
                              child: HomeWelcomeCard(
                                user: user,
                                totalBatches: totalBatches,
                              ),
                            ),

                            const SizedBox(height: 20),

                            BlocBuilder<ProductionCubit, ProductionState>(
                              builder: (context, state) {
                                if (state is ProductionBatchesLoaded) {
                                  final batches = state.batches;

                                  final total = batches.length;
                                  final passed = batches
                                      .where(
                                        (b) =>
                                            b.status ==
                                            AppConstants.statusPassed,
                                      )
                                      .length;
                                  final issues = batches
                                      .where(
                                        (b) =>
                                            b.status ==
                                            AppConstants.statusFailed,
                                      )
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

                            const SizedBox(height: 28),

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
              ),
            ),
          ),
        );
      },
    );
  }
}
