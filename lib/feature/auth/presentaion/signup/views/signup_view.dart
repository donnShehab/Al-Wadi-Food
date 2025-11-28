import 'package:alwadi_food/core/services/get_it_service.dart';
import 'package:alwadi_food/feature/auth/domain/repos/auth_repo.dart';
import 'package:alwadi_food/feature/auth/presentaion/cubits/signup_cubit/signup_cubit.dart';
import 'package:alwadi_food/feature/auth/presentaion/signup/views/widget/signup_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignupCubit(getIt<AuthRepo>()),
        child: SignupViewBodyBlocConsumer(),
      ),
    );
  }
}

class SignupViewBodyBlocConsumer extends StatelessWidget {
  const SignupViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupCubitSuccess) {
          Navigator.pop(context);
        }
        if (state is SignupCubitFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is SignupCubitLoading ? true : false,
          child: const SignupViewBody(),
        );
      },
    );
  }
}
