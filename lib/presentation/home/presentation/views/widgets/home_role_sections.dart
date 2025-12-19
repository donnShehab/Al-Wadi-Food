

import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/animations/staggered_fade_slide_item.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_navigation_card.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class HomeRoleSections extends StatelessWidget {
  final String role;
  final ThemeData theme;

  const HomeRoleSections({super.key, required this.role, required this.theme});

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case AppConstants.roleSupervisor:
        return _supervisorSection(context);

      case AppConstants.roleQC:
        return _qcSection(context);

      case AppConstants.roleManager:
        return _managerSection(context);

      default:
        return const SizedBox();
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(title, style: theme.textTheme.titleLarge?.semiBold),
    );
  }

  // ================= SUPERVISOR =================

  Widget _supervisorSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StaggeredSlideFade(
            index: 0,
        delay: const Duration(milliseconds: 100),
        offsetY: 20,
          
          child: _sectionTitle('Production Module')),
        StaggeredSlideFade(
          index: 1,
          delay: const Duration(milliseconds: 220),
          offsetY: 26,
          child: HomeNavigationCard(
            title: 'Create Batch',
            subtitle: 'Start a new production batch',
            icon: Icons.add_box,
            color: LightModeColors.lightPrimary,
            route: AppRouter.KcreateBatchView,
          ),
        ),
        StaggeredSlideFade(
          index: 2,
          delay: const Duration(milliseconds: 340),
          offsetY: 26,
          child: HomeNavigationCard(
            title: 'View Batches',
            subtitle: 'See all production batches',
            icon: Icons.view_list,
            color: LightModeColors.lightSecondary,
            route: AppRouter.KbatchListView,
          ),
        ),
      ],
    );
  }

  // ================= QC =================
Widget _qcSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StaggeredSlideFade(
          index: 0,
          delay: const Duration(milliseconds: 100),
          offsetY: 20,
          child: _sectionTitle('Quality Control'),
        ),

        /// 🧠 QC Dashboard (المدخل الرئيسي)
        StaggeredSlideFade(
          index: 1,
          delay: const Duration(milliseconds: 220),
          offsetY: 26,
          child: HomeNavigationCard(
            title: 'QC Dashboard',
            subtitle: 'Overview of inspections & performance',
            icon: Icons.dashboard_customize,
            color: LightModeColors.lightTertiary,
            route: '/qc-dashboard',
          ),
        ),

        /// 🕒 Pending QC
        StaggeredSlideFade(
          index: 2,
          delay: const Duration(milliseconds: 340),
          offsetY: 26,
          child: HomeNavigationCard(
            title: 'Pending Inspections',
            subtitle: 'Batches waiting for QC',
            icon: Icons.assignment,
            color: LightModeColors.lightSecondary,
            route: AppRouter.KqCPendingListView,
          ),
        ),
      ],
    );
  }

  // ================= MANAGER =================

  Widget _managerSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StaggeredSlideFade(
           index: 0,
          delay: const Duration(milliseconds: 100),
          offsetY: 20,
          child: _sectionTitle('Manager Dashboard')),
        StaggeredSlideFade(
           index: 1,
          delay: const Duration(milliseconds: 220),
          offsetY: 26,
          child: HomeNavigationCard(
            title: 'Dashboard',
            subtitle: 'Analytics and insights',
            icon: Icons.dashboard,
            color: LightModeColors.lightPrimary,
            route: AppRouter.KdashboardView,
          ),
        ),
        StaggeredSlideFade(
           index: 2,
          delay: const Duration(milliseconds: 340),
          offsetY: 26,
          child: HomeNavigationCard(
            title: 'Traceability',
            subtitle: 'Full batch tracking',
            icon: Icons.track_changes,
            color: LightModeColors.lightSecondary,
            route: AppRouter.KtraceabilityView,
          ),
        ),
        StaggeredSlideFade(
           index: 3,
          delay: const Duration(milliseconds: 460),
          offsetY: 26,
          child: HomeNavigationCard(
            title: 'User Management',
            subtitle: 'Manage users and roles',
            icon: Icons.people,
            color: LightModeColors.lightTertiary,
            route: AppRouter.KuserManagementView,
          ),
        ),
        StaggeredSlideFade(
           index: 4,
          delay: const Duration(milliseconds: 680),
          offsetY: 26,
          child: HomeNavigationCard(
            title: 'All Batches',
            subtitle: 'View all production batches',
            icon: Icons.view_list,
            color: LightModeColors.lightSuccess,
            route: AppRouter.KbatchListView,
          ),
        ),
      ],
    );
  }
}
