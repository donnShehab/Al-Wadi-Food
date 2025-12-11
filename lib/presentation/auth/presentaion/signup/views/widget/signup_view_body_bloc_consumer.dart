import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/auth/presentaion/signup/views/widget/signup_view_body.dart';
import 'package:alwadi_food/presentation/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupViewBlocConsumer extends StatelessWidget {
  const SignupViewBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go(AppRouter.KhomeView);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is AuthLoading,
          child: const SignupViewBody(),
        );
      },
    );
  }
}
