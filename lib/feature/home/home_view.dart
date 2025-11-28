import 'package:alwadi_food/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.alwadiOrange,
      body: Column(children: [Text('helooooooooo')]),
    );
  }
}
