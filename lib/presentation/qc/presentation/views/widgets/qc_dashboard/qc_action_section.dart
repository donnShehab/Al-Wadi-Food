import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class QCActionSection extends StatelessWidget {
  final int pendingCount;

  const QCActionSection({super.key, required this.pendingCount});

  @override
  Widget build(BuildContext context) {
    return QCActionCard(
      pendingCount: pendingCount,
      onStart: pendingCount == 0
          ? null
          : () async {
              final result = await context.push(AppRouter.KqCPendingListView);

              if (result == true && context.mounted) {
                context.read<QCCubit>().loadQCDashboard();
              }
            },
    );
  }
}
