import 'package:alwadi_food/presentation/auth/presentaion/signup/views/widget/signup_view_body_bloc_consumer.dart';
import 'package:alwadi_food/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'SignUp', context),
      body: BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: const SignupViewBlocConsumer(),
      ),
    );
  }
}
