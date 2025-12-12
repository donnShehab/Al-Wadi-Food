import 'package:flutter/material.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/home/presentation/views/widgets/home_navigation_card.dart';
import 'package:alwadi_food/theme.dart';

class HomeRoleSections extends StatelessWidget {
  final String role;
  final ThemeData theme;

  const HomeRoleSections({super.key, required this.role, required this.theme});

  @override
  Widget build(BuildContext context) {
    if (role == AppConstants.roleSupervisor) {
      return _buildModule("Production Module", [
        HomeNavigationCard(
          title: "Create Batch",
          subtitle: "Start a new production batch",
          icon: Icons.add_box,
          color: LightModeColors.lightPrimary,
          route: "/create-batch",
        ),
        HomeNavigationCard(
          title: "View Batches",
          subtitle: "See all production batches",
          icon: Icons.view_list,
          color: LightModeColors.lightSecondary,
          route: "/batches",
        ),
      ]);
    }

    if (role == AppConstants.roleQC) {
      return _buildModule("Quality Control", [
        HomeNavigationCard(
          title: "Pending QC",
          subtitle: "Batches awaiting inspection",
          icon: Icons.assignment,
          color: LightModeColors.lightTertiary,
          route: "/qc-pending",
        ),
        HomeNavigationCard(
          title: "All Batches",
          subtitle: "View all production batches",
          icon: Icons.inventory_2,
          color: LightModeColors.lightSecondary,
          route: "/batches",
        ),
      ]);
    }

    return _buildModule("Manager Dashboard", [
      HomeNavigationCard(
        title: "Dashboard",
        subtitle: "Analytics & insights",
        icon: Icons.dashboard,
        color: LightModeColors.lightPrimary,
        route: "/dashboard",
      ),
      HomeNavigationCard(
        title: "Traceability",
        subtitle: "Track full batch lifecycle",
        icon: Icons.track_changes,
        color: LightModeColors.lightSecondary,
        route: "/traceability",
      ),
      HomeNavigationCard(
        title: "User Management",
        subtitle: "Manage users",
        icon: Icons.people,
        color: LightModeColors.lightTertiary,
        route: "/users",
      ),
    ]);
  }

  Widget _buildModule(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }
}
