import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_view_body_bloc_consumer.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return
    // get an instance of the cubit vid dependency injection
    // we call the function to fetch user data fromfirebase ..loadUser()
     BlocProvider(
      create: (_) => getIt<ProductionCubit>()..listenToBatchesStream(),
      child: HomeViewBodyBlocConsumer(),
    );
  }
}
