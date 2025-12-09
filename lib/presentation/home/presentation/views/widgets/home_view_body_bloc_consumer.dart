import 'package:alwadi_food/presentation/home/cubit/home_cubit.dart';
import 'package:alwadi_food/presentation/home/cubit/home_state.dart';
import 'package:alwadi_food/presentation/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_view_body_content.dart';

class HomeViewBodyBlocConsumer extends StatelessWidget {
  const HomeViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is HomeLoading,
          child: Scaffold(
            body: state is HomeLoaded
                ? HomeViewBodyContent(user: state.user)
                : state is HomeError
                ? Center(child: Text(state.message))
                : const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
