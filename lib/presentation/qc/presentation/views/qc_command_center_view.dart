import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/presentation/qc/presentation/views/qc_analytics_view.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/qc_insights_view.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/qc_reports_view.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_state.dart';
import 'widgets/qc_dashboard/qc_dashboard_body.dart';

class QCCommandCenterView extends StatefulWidget {
  const QCCommandCenterView({super.key});

  @override
  State<QCCommandCenterView> createState() => _QCCommandCenterViewState();
}

class _QCCommandCenterViewState extends State<QCCommandCenterView> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // تأكد من أن الـ Cubit متوفر في الـ context
    context.read<QCCubit>().loadQCDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.35,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primary.withOpacity(0.035),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _ExecutiveTopBar(
                title: "QC Command Center",
                onBack: () => Navigator.maybePop(context),
              ),
              Expanded(
                child: BlocBuilder<QCCubit, QCState>(
                  builder: (context, state) {
                    if (state is QCLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is QCError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (state is QCDashboardLoaded) {
                      final pages = [
                        QCDashboardBody(
                          pendingCount: state.pendingCount,
                          passedToday: state.passedToday,
                          failedToday: state.failedToday,
                          recentResults: state.recentResults,
                          riskLevel: state.riskLevel,
                          alerts: state.alerts,
                          trend: state.trend,
                          recommendations: state.recommendations,
                        ),
                        const QCAnalyticsView(),
                        const QCInsightsView(),
                        const QCReportsView(),
                      ];

                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: pages[_index],
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
              _ExecutiveNavBar(
                selectedIndex: _index,
                onDestinationSelected: (value) {
                  setState(() => _index = value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExecutiveTopBar extends StatelessWidget {
  const _ExecutiveTopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.85),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 18,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _ExecutiveNavBar extends StatelessWidget {
  const _ExecutiveNavBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = const [
      _NavItem(
        label: "Overview",
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
      ),
      _NavItem(
        label: "Analytics",
        icon: Icons.show_chart_outlined,
        activeIcon: Icons.show_chart,
      ),
      _NavItem(
        label: "Insights",
        icon: Icons.lightbulb_outline,
        activeIcon: Icons.lightbulb,
      ),
      _NavItem(
        label: "Reports",
        icon: Icons.picture_as_pdf_outlined,
        activeIcon: Icons.picture_as_pdf,
      ),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          14,
          8,
          14,
          12,
        ), // تعديل بسيط في الهوامش
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              // تم استبدال الطول الثابت بـ constraints لتجنب الـ overflow
              constraints: const BoxConstraints(minHeight: 70, maxHeight: 85),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.78),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(items.length, (i) {
                  return Expanded(
                    child: _NavButton(
                      isActive: i == selectedIndex,
                      item: items[i],
                      onTap: () => onDestinationSelected(i),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.isActive,
    required this.item,
    required this.onTap,
  });

  final bool isActive;
  final _NavItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeBg = theme.colorScheme.primary.withOpacity(0.14);
    final activeFg = theme.colorScheme.primary;
    final idleFg = theme.colorScheme.onSurfaceVariant;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive
                ? theme.colorScheme.primary.withOpacity(0.22)
                : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // يضمن عدم تمدد العناصر بشكل زائد
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                key: ValueKey<bool>(isActive),
                size: 20, // تصغير حجم الأيقونة قليلاً
                color: isActive ? activeFg : idleFg,
              ),
            ),
            const SizedBox(height: 4), // تقليل المسافة الفاصلة
            Flexible(
              // إضافة Flexible لضمان احتواء النص
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                style: theme.textTheme.labelSmall!.copyWith(
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  color: isActive ? activeFg : idleFg,
                  fontSize: 10, // تحديد حجم خط ثابت وصغير
                  letterSpacing: -0.1,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
