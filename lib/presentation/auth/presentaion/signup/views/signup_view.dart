import 'package:alwadi_food/presentation/auth/presentaion/signup/views/widget/signup_view_body_bloc_consumer.dart';
import 'package:alwadi_food/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(title: 'SignUp', context),
      body:  SignupViewBlocConsumer(),
      
    );
  }
}
