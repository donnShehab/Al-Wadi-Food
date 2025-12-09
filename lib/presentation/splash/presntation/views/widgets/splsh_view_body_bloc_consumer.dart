import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/splash/presntation/views/widgets/splash_view_body.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashViewBodyBlocConsumer extends StatelessWidget {
  const SplashViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocListener<AuthCubit, AuthState>(
     listener: (context, state) {
        if (state is AuthSuccess) {
          context.go(AppRouter.KhomeView);
        } else if (state is AuthFailure || state is AuthInitial) {
          context.go(AppRouter.KloginView);
        }
      },

      child: const SplashViewBody(),
    );
  }
}
