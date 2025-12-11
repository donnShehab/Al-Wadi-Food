import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/auth/presentaion/signin/views/widgets/signin_view_body_bloc_cunsumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const SigninViewBlocConsumer(),
    );
  }
}
