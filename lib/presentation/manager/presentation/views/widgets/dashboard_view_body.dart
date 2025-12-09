import 'package:alwadi_food/presentation/manager/cubit/dashboard_state.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/dashboard/batch_stat_card.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/dashboard/production_bar_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../../theme.dart';

class DashboardViewBody extends StatelessWidget {
  final DashboardData data;

  const DashboardViewBody({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Production Overview',
            style: Theme.of(context).textTheme.titleLarge?.semiBold,
          ),
          const SizedBox(height: AppSpacing.md),

          /// Cards Row 1
          Row(
            children: [
              Expanded(
                child: BatchStatCard(
                  title: 'Total',
                  value: data.totalBatches,
                  icon: Icons.inventory_2,
                  color: LightModeColors.lightPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: BatchStatCard(
                  title: 'Passed',
                  value: data.passedBatches,
                  icon: Icons.check_circle,
                  color: LightModeColors.lightSuccess,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          /// Cards Row 2
          Row(
            children: [
              Expanded(
                child: BatchStatCard(
                  title: 'Failed',
                  value: data.failedBatches,
                  icon: Icons.cancel,
                  color: LightModeColors.lightError,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: BatchStatCard(
                  title: 'Pending',
                  value: data.waitingQCBatches,
                  icon: Icons.pending,
                  color: LightModeColors.lightTertiary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),
          Text(
            'Production by Line',
            style: Theme.of(context).textTheme.titleLarge?.semiBold,
          ),
          const SizedBox(height: AppSpacing.md),

          ProductionBarChart(lines: data.productionByLine),
        ],
      ),
    );
  }
}
