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
    // UI-only: executive section header (title + subtle divider line).
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Text(title, style: theme.textTheme.titleLarge?.semiBold),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.onSurface.withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
          child: _sectionTitle('Production Module'),
        ),
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
        StaggeredSlideFade(
          index: 1,
          delay: const Duration(milliseconds: 220),
          offsetY: 26,
          child: HomeNavigationCard(
            title: 'QC Dashboard',
            subtitle: 'Overview of inspections & workload',
            icon: Icons.dashboard_outlined,
            color: LightModeColors.lightPrimary,
            route: AppRouter.KQCDashboardView,
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
          child: _sectionTitle('Manager Module'),
        ),
        StaggeredSlideFade(
          index: 1,
          delay: const Duration(milliseconds: 220),
          offsetY: 26,
          child: HomeNavigationCard(
            title: 'Manager Control Center',
            subtitle: 'Dashboard • Alerts • Reports • Traceability • More',
            icon: Icons.space_dashboard_rounded,
            color: LightModeColors.lightPrimary,
            route: AppRouter.KManagerMainView,
          ),
        ),
      ],
    );
  }
}
