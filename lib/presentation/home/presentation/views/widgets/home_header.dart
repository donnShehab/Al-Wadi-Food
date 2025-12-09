import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:alwadi_food/presentation/home/cubit/home_cubit.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeHeader extends StatelessWidget {
  final UserEntity user;
  const HomeHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user.name}',
              style: theme.textTheme.headlineMedium?.bold,
            ),
            const SizedBox(height: 4),
            Text(
              user.role.toUpperCase(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              tooltip: 'Settings',
              icon: Icon(Icons.settings, color: theme.colorScheme.primary),
              onPressed: () => context.push('/settings'),
            ),
            IconButton(
              tooltip: 'Sign out',
              icon: Icon(Icons.logout, color: theme.colorScheme.error),
              onPressed: () {
                context.read<AuthCubit>().signOut();
                context.go('/login');
              },
            ),
          ],
        ),
      ],
    );
  }
}
