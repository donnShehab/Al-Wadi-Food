
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
import 'package:alwadi_food/presentation/home/cubit/home_cubit.dart';
import 'package:alwadi_food/presentation/home/cubit/home_state.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_skeleton.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_view_body_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewBodyBlocConsumer extends StatelessWidget {
  const HomeViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthSuccess) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = authState.user; // ✅ المصدر الوحيد

        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, homeState) {
            if (homeState is HomeInitial) {
              context.read<HomeCubit>().loadStats(); // ✅ بدون user
            }

            if (homeState is HomeLoading) {
              return const HomeSkeleton();
            }

            if (homeState is HomeFullyLoaded) {
              return HomeViewBodyContent(
                user: user, // 👈 من AuthCubit
                totalBatches: homeState.totalBatches,
                passedQC: homeState.passedQC,
                issues: homeState.issues,
              );
            }

            if (homeState is HomeError) {
              return Center(child: Text(homeState.message));
            }

            return const SizedBox();
          },
        );
      },
    );
  }
}
