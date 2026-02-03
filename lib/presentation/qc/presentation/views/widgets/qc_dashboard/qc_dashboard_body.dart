import 'package:alwadi_food/presentation/qc/domain/entites/qc_alert_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_recommendation_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_trend_day_entity.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_action_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_alerts_list.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_header_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_hint_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_kpi_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_recent_activity_section.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_risk_alert_card.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class QCDashboardBody extends StatelessWidget {
  final int pendingCount;
  final int passedToday;
  final int failedToday;
  final List<QCResultEntity> recentResults;

  // موجودين من cubit بس مش رح نعرضهم هنا
  final String riskLevel;
  final List<QCAlertEntity> alerts;
  final List<QCTrendDayEntity> trend;
  final List<QCRecommendation> recommendations;

  const QCDashboardBody({
    super.key,
    required this.pendingCount,
    required this.passedToday,
    required this.failedToday,
    required this.recentResults,
    required this.riskLevel,
    required this.alerts,
    required this.trend,
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ✅ HEADER (KEEP EXACT)
          const QCHeaderSection(),
          const SizedBox(height: 16),

          /// ✅ Executive page heading (UI only)
          // Text(
          //   'Quality Control Overview',
          //   style: theme.textTheme.headlineSmall?.copyWith(
          //     fontWeight: FontWeight.w900,
          //     letterSpacing: -0.2,
          //     color: theme.colorScheme.onSurface.withOpacity(0.92),
          //   ),
          // ),
          // const SizedBox(height: 6),
          // Text(
          //   'Live QC performance monitoring & inspection tracking',
          //   style: theme.textTheme.bodyMedium?.copyWith(
          //     color: theme.colorScheme.onSurfaceVariant.withOpacity(0.78),
          //     height: 1.25,
          //   ),
          // ),
          // const SizedBox(height: 14),
          Divider(
            height: 1,
            thickness: 1,
            color: theme.colorScheme.onSurface.withOpacity(0.06),
          ),
          const SizedBox(height: 18),

          /// ✅ KPIs (TODAY) - framed as executive surface
          _ExecutiveSurface(
            child: QCKPISection(
              pendingCount: pendingCount,
              passedToday: passedToday,
              failedToday: failedToday,
            ),
          ),

          const SizedBox(height: 18),

          /// ✅ ACTION SECTION (primary)
          _ExecutiveSurface(child: QCActionSection(pendingCount: pendingCount)),

          const SizedBox(height: 14),

          /// ✅ HINT (daily note)
          const _ExecutiveSurface(child: QCHintSection()),

          const SizedBox(height: 18),

          /// ✅ RECENT ACTIVITY
          _SectionHeader(title: 'Recent QC Activity'),
          const SizedBox(height: 12),

          _ExecutiveSurface(
            child: QCRecentActivitySection(
              recentResults: recentResults.take(3).toList(),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

/// ===========================
///  Executive Surface Wrapper
/// ===========================
/// UI-only wrapper to unify look without touching logic/widgets inside.
class _ExecutiveSurface extends StatelessWidget {
  const _ExecutiveSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = theme.colorScheme.onSurface.withOpacity(0.08);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// ===========================
///  Section Header
/// ===========================
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.65),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }
}
