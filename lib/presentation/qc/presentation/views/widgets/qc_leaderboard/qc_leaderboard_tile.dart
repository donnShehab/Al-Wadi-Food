import 'package:alwadi_food/presentation/qc/domain/entites/qc_leaderboard_entry_entity.dart';
import 'package:flutter/material.dart';

class QCLeaderboardTile extends StatelessWidget {
  final QCLeaderboardEntryEntity entry;
  final int rank;

  const QCLeaderboardTile({super.key, required this.entry, required this.rank});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color rankColor = rank == 1
        ? Colors.amber
        : rank == 2
        ? Colors.grey
        : rank == 3
        ? Colors.brown
        : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: rankColor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: rankColor.withOpacity(0.15),
            child: Text(
              "$rank",
              style: TextStyle(fontWeight: FontWeight.bold, color: rankColor),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.inspectorName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Inspections: ${entry.totalInspections} • Passed: ${entry.passed} • Failed: ${entry.failed}",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${entry.passRate.toStringAsFixed(1)}%",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: rankColor,
            ),
          ),
        ],
      ),
    );
  }
}
