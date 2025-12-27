import 'package:alwadi_food/presentation/qc/cubit/qc_leaderboard/qc_leaderboard_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_leaderboard/qc_leaderboard_state.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_leaderboard/qc_leaderboard_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QCLeaderboardViewBodyBlocConsumer extends StatelessWidget {
  const QCLeaderboardViewBodyBlocConsumer({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text("QC Leaderboard"),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "weekly") {
                context.read<QCLeaderboardCubit>().loadWeekly();
              } else {
                context.read<QCLeaderboardCubit>().loadMonthly();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: "weekly", child: Text("Weekly")),
              PopupMenuItem(value: "monthly", child: Text("Monthly")),
            ],
          ),
        ],
      ),
      body: BlocBuilder<QCLeaderboardCubit, QCLeaderboardState>(
        builder: (context, state) {
          if (state is QCLeaderboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QCLeaderboardError) {
            return Center(child: Text(state.message));
          }

          if (state is QCLeaderboardLoaded) {
            if (state.entries.isEmpty) {
              return const Center(child: Text("No inspections available."));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(18),
              itemCount: state.entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = state.entries[index];
                return QCLeaderboardTile(entry: entry, rank: index + 1);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
