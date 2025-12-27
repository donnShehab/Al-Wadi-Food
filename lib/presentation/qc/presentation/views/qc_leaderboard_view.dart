import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_leaderboard/qc_leaderboard_cubit.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_leaderboard/qc_leaderboard_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QCLeaderboardView extends StatelessWidget {
  const QCLeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QCLeaderboardCubit>()..loadWeekly(),
      child: const QCLeaderboardViewBody(),
    );
  }
}
