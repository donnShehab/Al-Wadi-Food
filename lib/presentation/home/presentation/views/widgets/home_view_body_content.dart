import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:alwadi_food/presentation/home/cubit/home_cubit.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_header.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_role_optioins.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class HomeViewBodyContent extends StatelessWidget {
  final UserEntity user;
  const HomeViewBodyContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(user: user),
            const SizedBox(height: 32),
            if (user.role == AppConstants.roleSupervisor)
              SupervisorOptions(theme: theme),
            if (user.role == AppConstants.roleQC) QCOptions(theme: theme),
            if (user.role == AppConstants.roleManager)
              ManagerOptions(theme: theme),
          ],
        ),
      ),
    );
  }
}
