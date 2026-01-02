import 'package:alwadi_food/presentation/manager/cubit/manager_nav/manager_nav_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_nav/manager_nav_state.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/manager_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagerMainViewBodyBlocConsumer extends StatelessWidget {
  final ThemeData theme;
  const ManagerMainViewBodyBlocConsumer({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ManagerDashboardView(), // ✅ Tab 0 Dashboard (صفحتك الجاهزة)
      const _PlaceholderPage(title: "Alerts & Risks"), // 🚧 Tab 1
      const _PlaceholderPage(title: "Reports Center"), // 🚧 Tab 2
      const _PlaceholderPage(title: "Traceability"), // 🚧 Tab 3
      const _PlaceholderPage(title: "More (Users/Performance)"), // 🚧 Tab 4
    ];

    return BlocBuilder<ManagerNavCubit, ManagerNavState>(
      builder: (context, state) {
        return Scaffold(
          body: pages[state.index],

          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: state.index,
              onTap: (i) => context.read<ManagerNavCubit>().changeTab(i),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: theme.colorScheme.primary,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_rounded),
                  label: "Dashboard",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.warning_amber_rounded),
                  label: "Alerts",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.picture_as_pdf_rounded),
                  label: "Reports",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.track_changes_rounded),
                  label: "Trace",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz_rounded),
                  label: "More",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// مؤقتة لحد ما نبني صفحات Alerts/Reports/Traceability
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
