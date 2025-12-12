
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
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) async {
        if (state is HomeUserLoaded) {
          await context.read<HomeCubit>().loadStats(state.user);
        }
      },
      builder: (context, state) {
      if (state is HomeLoading) {
          return const HomeSkeleton();
        }

        if (state is HomeFullyLoaded) {
          return HomeViewBodyContent(
            user: state.user,
            totalBatches: state.totalBatches,
            passedQC: state.passedQC,
            issues: state.issues,
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
