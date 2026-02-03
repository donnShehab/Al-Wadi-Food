import 'dart:math' as math;
import 'dart:ui';

import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_dashboard/manager_dashboard_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_dashboard/manager_dashboard_state.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_nav/manager_nav_cubit.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ManagerDashboardViewBodyBlocConsumer extends StatelessWidget {
  final ThemeData theme;

  const ManagerDashboardViewBodyBlocConsumer({super.key, required this.theme});

  static const double _sectionSpacing = 24;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManagerDashboardCubit, ManagerDashboardState>(
      listener: (context, state) {
        if (state is ManagerDashboardError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final String name = (state is ManagerDashboardLoaded)
            ? state.data.managerName
            : 'Manager';

        final int notifCount = (state is ManagerDashboardLoaded)
            ? state.executive.notificationCount
            : 0;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _ExecutiveAppBar(
            name: name,
            notificationCount: notifCount,
            onBellTap: () => _goToActionNeeded(context),
          ),
          body: DecoratedBox(
            decoration: _executiveBackgroundDecoration(theme),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () =>
                    context.read<ManagerDashboardCubit>().loadDashboard(),
                child: _buildBody(context, state),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ManagerDashboardState state) {
    if (state is ManagerDashboardInitial || state is ManagerDashboardLoading) {
      return const _DashboardLoadingSkeleton();
    }

    if (state is ManagerDashboardError) {
      return _DashboardErrorState(
        message: state.message,
        onRetry: () => context.read<ManagerDashboardCubit>().loadDashboard(),
      );
    }

    if (state is ManagerDashboardLoaded) {
      final metrics = state.executive;
      final data = state.data;

      // Smooth fade-in when loaded
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.paddingLg,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1) Health Score Card
              _HealthScoreCard(metrics: metrics),
              const SizedBox(height: _sectionSpacing),

              // 2) Decisions Waiting CTA (directly below health card)
              _DecisionsWaitingCta(
                count: metrics.decisionsWaitingCount,
                onReviewAndTakeAction: () => _goToActionNeeded(context),
              ),
              const SizedBox(height: _sectionSpacing),

              // 3) Top 3 Priorities (3 horizontal elegant cards)
              _Top3PrioritiesSection(
                slaExceededCount: metrics.slaExceededCount,
                highRiskCount: metrics.highRiskAlertCount,
                inspectionsToday: data.qcInspectionsToday,
                passRate: data.passRate,
                onOpen: () => _goToActionNeeded(context),
              ),

              const SizedBox(height: _sectionSpacing),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// =============================================================
// AppBar (Sleek)
// =============================================================

class _ExecutiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final int notificationCount;
  final VoidCallback onBellTap;

  const _ExecutiveAppBar({
    required this.name,
    required this.notificationCount,
    required this.onBellTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final safeName = name.trim().isEmpty ? 'Manager' : name.trim();
    final initial = safeName.substring(0, 1).toUpperCase();

    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 16,
      flexibleSpace: _ExecutiveAppBarSurface(theme: t),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: t.colorScheme.primary.withOpacity(0.12),
            child: Text(
              initial,
              style: t.textTheme.titleMedium?.copyWith(
                color: t.colorScheme.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Hello, $safeName',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: t.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
      actions: [
        _NotificationBell(count: notificationCount, onTap: onBellTap),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _ExecutiveAppBarSurface extends StatelessWidget {
  final ThemeData theme;
  const _ExecutiveAppBarSurface({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: _executiveBackgroundDecoration(theme),
          ),
        ),
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.72),
                  border: Border(
                    bottom: BorderSide(color: Colors.black.withOpacity(0.05)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationBell extends StatelessWidget {
  final VoidCallback onTap;
  final int count;

  const _NotificationBell({required this.onTap, required this.count});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder هو "المراقب" الذي يستمع للتغييرات في الـ Cubit
    return ValueListenableBuilder<int>(
      valueListenable: ManagerActionNeededCubit.pendingCountNotifier,
      builder: (context, count, child) {
        return GestureDetector(
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.black87,
                ),
              ),
              // لا تظهر الدائرة الحمراء إلا إذا كان هناك مهام (count > 0)
              if (count > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFDC143C), // Crimson Red
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
// =============================================================
// Health Score Card (kept from Phase 1)
// =============================================================

class _HealthScoreCard extends StatelessWidget {
  final ManagerDashboardExecutiveMetrics metrics;

  const _HealthScoreCard({required this.metrics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = metrics.healthScore;

    final Color base = _healthColor(score);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _GradientScoreRing(score: score, color: base),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Score',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  metrics.statusMessage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: base,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetricChip(
                      icon: Icons.task_alt_rounded,
                      label: 'Decisions',
                      value: metrics.decisionsWaitingCount,
                    ),
                    _MetricChip(
                      icon: Icons.warning_amber_rounded,
                      label: 'High Risk',
                      value: metrics.highRiskAlertCount,
                    ),
                    _MetricChip(
                      icon: Icons.timer_rounded,
                      label: 'SLA',
                      value: metrics.slaExceededCount,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientScoreRing extends StatelessWidget {
  final int score;
  final Color color;

  const _GradientScoreRing({required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final double progress = (score / 100).clamp(0.0, 1.0).toDouble();

    return SizedBox(
      width: 120,
      height: 120,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: progress),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          return CustomPaint(
            painter: _GradientCircularProgressPainter(
              progress: value,
              color: color,
              strokeWidth: 12,
            ),
            child: Center(
              child: Text(
                '$score',
                style: t.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                  height: 1.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final double progress; // 0..1
  final Color color;
  final double strokeWidth;

  _GradientCircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (math.min(size.width, size.height) / 2) - strokeWidth / 2;
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    final basePaint = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, -math.pi / 2, 2 * math.pi, false, basePaint);

    if (progress <= 0) return;

    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + (2 * math.pi * progress),
      colors: [color.withOpacity(0.20), color],
    );

    final paint = Paint()
      ..shader = gradient.createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, -math.pi / 2, 2 * math.pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// Decisions Waiting CTA (Phase 2)
// =============================================================

class _DecisionsWaitingCta extends StatelessWidget {
  final int count;
  final VoidCallback onReviewAndTakeAction;

  const _DecisionsWaitingCta({
    required this.count,
    required this.onReviewAndTakeAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const bg = Color(0xFF1E1B4B); // Deep Indigo (high contrast)
    const fg = Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecorationColored(bg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending Decisions',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: fg.withOpacity(0.90),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$count',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Failed inspections awaiting manager action.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: fg.withOpacity(0.75),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: bg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
              ),
              onPressed: onReviewAndTakeAction,
              child: const Text(
                'Review & Take Action',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// Top 3 Priorities (Phase 2 summary cards)
// =============================================================

class _Top3PrioritiesSection extends StatelessWidget {
  final int slaExceededCount;
  final int highRiskCount;
  final int inspectionsToday;
  final double passRate;
  final VoidCallback onOpen;

  const _Top3PrioritiesSection({
    required this.slaExceededCount,
    required this.highRiskCount,
    required this.inspectionsToday,
    required this.passRate,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cards = <_PrioritySummaryCardModel>[
      _PrioritySummaryCardModel(
        title: 'Delay',
        icon: Icons.timer_rounded,
        accent: const Color(0xFFF4B400),
        primaryText: slaExceededCount > 0
            ? '$slaExceededCount Batches Delayed'
            : 'No delays detected',
        chipLabel: 'Review',
      ),
      _PrioritySummaryCardModel(
        title: 'Quality',
        icon: Icons.thermostat_rounded,
        accent: const Color(0xFFDC143C),
        primaryText: highRiskCount > 0
            ? 'Temp Anomaly • $highRiskCount'
            : 'No anomalies detected',
        chipLabel: 'Inspect',
      ),
      _PrioritySummaryCardModel(
        title: 'Efficiency',
        icon: Icons.speed_rounded,
        accent: const Color(0xFF16A085),
        primaryText:
            '$inspectionsToday inspections • ${passRate.toStringAsFixed(0)}% pass',
        chipLabel: 'Details',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top 3 Priorities',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 138,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final c = cards[index];
              return _PrioritySummaryCard(model: c, onOpen: onOpen);
            },
          ),
        ),
      ],
    );
  }
}

class _PrioritySummaryCardModel {
  final String title;
  final IconData icon;
  final Color accent;
  final String primaryText;
  final String chipLabel;

  const _PrioritySummaryCardModel({
    required this.title,
    required this.icon,
    required this.accent,
    required this.primaryText,
    required this.chipLabel,
  });
}

class _PrioritySummaryCard extends StatelessWidget {
  final _PrioritySummaryCardModel model;
  final VoidCallback onOpen;

  const _PrioritySummaryCard({required this.model, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 260,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      // حل مشكلة الـ Overflow باستخدام ConstrainedBox و Flexible
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: model.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(model.icon, color: model.accent, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                model.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // الـ Flexible هنا يضمن أن النص يأخذ المساحة المتاحة فقط
          Expanded(
            child: Text(
              model.primaryText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis, // وضع النقاط (...) عند طول النص
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 32, // تحديد ارتفاع ثابت للزر لتجنب الـ Overflow
            child: ActionChip(
              onPressed: onOpen,
              backgroundColor: const Color(0xFFF3F4F6),
              label: Text(
                model.chipLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// =============================================================
// Loading / Error
// =============================================================

class _DashboardLoadingSkeleton extends StatelessWidget {
  const _DashboardLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.paddingLg,
      child: Column(
        children: const [
          _SkeletonBox(height: 160),
          SizedBox(height: 24),
          _SkeletonBox(height: 120),
          SizedBox(height: 24),
          _SkeletonBox(height: 138),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double height;
  const _SkeletonBox({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: _cardDecoration(),
      child: Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _DashboardErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DashboardErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.paddingLg,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Failed to load dashboard',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// Styling Helpers
// =============================================================

BoxDecoration _executiveBackgroundDecoration(ThemeData theme) {
  return BoxDecoration(
    gradient: RadialGradient(
      center: Alignment.topCenter,
      radius: 1.25,
      colors: [
        theme.colorScheme.surface,
        theme.colorScheme.primary.withOpacity(0.035),
      ],
    ),
  );
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white.withOpacity(0.96),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: Colors.black.withOpacity(0.05)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 26,
        offset: const Offset(0, 16),
      ),
    ],
  );
}

BoxDecoration _cardDecorationColored(Color color) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: Colors.black.withOpacity(0.05)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 26,
        offset: const Offset(0, 16),
      ),
    ],
  );
}

Color _healthColor(int score) {
  // Emerald Green (Excellent), Golden Amber (Warning), Crimson Red (Critical)
  if (score >= 80) return const Color(0xFF2ECC71);
  if (score >= 50) return const Color(0xFFF4B400);
  return const Color(0xFFDC143C);
}

// =============================================================
// Navigation
// =============================================================

void _goToActionNeeded(BuildContext context) {
  // Works when dashboard is inside ManagerMainView (tabs).
  // Falls back to route when used standalone.
  try {
    context.read<ManagerNavCubit>().changeTab(1);
  } catch (_) {
    context.push(AppRouter.KManagerActionNeededView);
  }
}
