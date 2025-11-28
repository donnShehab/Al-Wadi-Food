import 'package:alwadi_food/core/helper_functions/app_router.dart';
import 'package:alwadi_food/core/services/get_it_service.dart';
import 'package:alwadi_food/core/utils/app_colors.dart';
import 'package:alwadi_food/core/utils/app_text_styles.dart';
import 'package:alwadi_food/core/widgets/custom_app_bar.dart';
import 'package:alwadi_food/feature/auth/domain/repos/auth_repo.dart';
import 'package:alwadi_food/feature/auth/presentaion/cubits/signin_cubit/signin_cubit.dart';
import 'package:alwadi_food/feature/auth/presentaion/signin/views/widgets/sigin_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SigninView extends StatelessWidget {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SigninCubit(getIt<AuthRepo>()),
        child: SigninViewBodyBlocConsumer(),
      ),
    );
  }
}

class SigninViewBodyBlocConsumer extends StatelessWidget {
  const SigninViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state is SigninSuccess) {
          GoRouter.of(context).push(AppRouter.kHomeView);
        }
        if (state is SigninFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is SigninSuccess ? true : false,
          child: SiginViewBody(),
        );
      },
    );
  }
}
