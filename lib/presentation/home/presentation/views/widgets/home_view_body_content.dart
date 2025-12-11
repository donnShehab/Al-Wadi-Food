import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_header.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_role_optioins.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

// the main user interface is displayed after login in -->
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
            // home header showing name and role and sign out button and setting button
            HomeHeader(user: user),
            const SizedBox(height: 32),
            // show role based options
            // role Supervisor
            if (user.role == AppConstants.roleSupervisor)
              SupervisorOptions(theme: theme),
            // role QC
            if (user.role == AppConstants.roleQC) QCOptions(theme: theme),
            // role Manager
            if (user.role == AppConstants.roleManager)
              ManagerOptions(theme: theme),
          ],
        ),
      ),
    );
  }
}
