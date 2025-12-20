import 'package:alwadi_food/presentation/qc/cubit/qc_dashboard/qc_dashboard_cubit.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_action_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_hint_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_stat_card.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/recent_qc_activity_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';

class QCDashboardBody extends StatelessWidget {
  final int pendingCount;
  final int passedToday;
  final int failedToday;
  final List<QCResultEntity> recentResults;

  const QCDashboardBody({
    super.key,
    required this.pendingCount,
    required this.passedToday,
    required this.failedToday,
    required this.recentResults,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quality Control Command Center',
            style: Theme.of(context).textTheme.headlineSmall?.semiBold,
          ),
          const SizedBox(height: 20),

          // Stats
          Row(
            children: [
              QCStatCard(
                title: 'Pending QC',
                value: pendingCount,
                icon: Icons.hourglass_bottom,
                iconColor: Colors.orange,
              ),
              const SizedBox(width: 12),
              QCStatCard(
                title: 'Passed Today',
                value: passedToday,
                icon: Icons.check_circle,
                iconColor: Colors.green,
              ),
              const SizedBox(width: 12),
              QCStatCard(
                title: 'Failed Today',
                value: failedToday,
                icon: Icons.cancel,
                iconColor: Colors.red,
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Action card
          // QCActionCard(
          //   pendingCount: pendingCount,
          //   onStart: pendingCount == 0
          //       ? null
          //       : () => context.push(AppRouter.KqCPendingListView),
          // ),
QCActionCard(
            pendingCount: pendingCount,
            onStart: pendingCount == 0
                ? null
                : () async {
                    final result = await context.push(
                      AppRouter.KqCPendingListView,
                    );

                    if (result == true && context.mounted) {
                      context.read<QCDashboardCubit>().loadDashboard();
                    }
                  },
          ),

          const SizedBox(height: 18),

          // Hint
          const QCHintCard(
            text:
                'Inspections should be completed promptly to avoid production delays.',
          ),

          if (recentResults.isNotEmpty) ...[
            const SizedBox(height: 28),
            RecentQCActivityList(results: recentResults),
          ] else ...[
            const SizedBox(height: 28),
            Text(
              'No recent QC activity yet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
