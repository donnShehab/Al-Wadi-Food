import 'package:alwadi_food/presentation/splash/presntation/views/widgets/splsh_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashViewBodyBlocConsumer(),
    );
  }
}
