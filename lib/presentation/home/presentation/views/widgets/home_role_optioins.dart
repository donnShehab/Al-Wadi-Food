import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home_navigation_card.dart';

class SupervisorOptions extends StatelessWidget {
  final ThemeData theme;
  const SupervisorOptions({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Production Module', style: theme.textTheme.titleLarge?.semiBold),
        const SizedBox(height: AppSpacing.md),
        HomeNavigationCard(
          title: 'Create Batch',
          subtitle: 'Start a new production batch',
          icon: Icons.add_box,
          color: LightModeColors.lightPrimary,
          route: '/create-batch',
        ),
        const SizedBox(height: AppSpacing.md),
        HomeNavigationCard(
          title: 'View Batches',
          subtitle: 'See all production batches',
          icon: Icons.view_list,
          color: LightModeColors.lightSecondary,
          route: '/batch-list',
        ),
      ],
    );
  }
}

class QCOptions extends StatelessWidget {
  final ThemeData theme;
  const QCOptions({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quality Control Module',
          style: theme.textTheme.titleLarge?.semiBold,
        ),
        const SizedBox(height: AppSpacing.md),
        HomeNavigationCard(
          title: 'Pending Inspections',
          subtitle: 'Batches waiting for QC',
          icon: Icons.assignment,
          color: LightModeColors.lightTertiary,
          route: '/qc-pending',
        ),
        const SizedBox(height: AppSpacing.md),
        HomeNavigationCard(
          title: 'All Batches',
          subtitle: 'View all production batches',
          icon: Icons.view_list,
          color: LightModeColors.lightSecondary,
          route: '/batch-list',
        ),
      ],
    );
  }
}

class ManagerOptions extends StatelessWidget {
  final ThemeData theme;
  const ManagerOptions({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Manager Dashboard', style: theme.textTheme.titleLarge?.semiBold),
        const SizedBox(height: AppSpacing.md),
        HomeNavigationCard(
          title: 'Dashboard',
          subtitle: 'Analytics and insights',
          icon: Icons.dashboard,
          color: LightModeColors.lightPrimary,
          route: '/dashboard',
        ),
        const SizedBox(height: AppSpacing.md),
        HomeNavigationCard(
          title: 'Traceability',
          subtitle: 'Full batch tracking',
          icon: Icons.track_changes,
          color: LightModeColors.lightSecondary,
          route: '/traceability',
        ),
        const SizedBox(height: AppSpacing.md),
        HomeNavigationCard(
          title: 'User Management',
          subtitle: 'Manage users and roles',
          icon: Icons.people,
          color: LightModeColors.lightTertiary,
          route: '/user-management',
        ),
        const SizedBox(height: AppSpacing.md),
        HomeNavigationCard(
          title: 'All Batches',
          subtitle: 'View all production batches',
          icon: Icons.view_list,
          color: LightModeColors.lightSuccess,
          route: '/batch-list',
        ),
      ],
    );
  }
}
