import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';

class QCTopFailureReasonsCard extends StatelessWidget {
  final List<QCResultEntity> results;

  const QCTopFailureReasonsCard({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    /// ✅ Filter last 7 days
    final lastWeekResults = results
        .where((r) => r.createdAt.isAfter(sevenDaysAgo))
        .toList();

    final failed = lastWeekResults
        .where((r) => r.failureReason != null)
        .toList();

    if (failed.isEmpty) {
      return _emptyCard(theme);
    }

    /// ✅ Count reasons
    final Map<String, int> reasonCounts = {};
    for (final r in failed) {
      final reason = r.failureReason ?? "Unknown";
      reasonCounts[reason] = (reasonCounts[reason] ?? 0) + 1;
    }

    final sortedReasons = reasonCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top3 = sortedReasons.take(3).toList();
    final maxReasonCount = top3.first.value;

    /// ✅ Worst Line (most failed)
    final Map<String, int> lineFails = {};
    for (final r in failed) {
      final line = r.productionLine.isEmpty ? "Unknown" : r.productionLine;
      lineFails[line] = (lineFails[line] ?? 0) + 1;
    }

    final worstLine = lineFails.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(theme),

          const SizedBox(height: 10),

          Text(
            "Most repeated QC failures in the last 7 days",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 16),

          /// ✅ Worst Line Highlight
          _worstLineChip(theme, worstLine.key, worstLine.value),

          const SizedBox(height: 18),

          /// ✅ reasons list
          ...top3.map((e) {
            final percent = e.value / maxReasonCount;

            return _failureReasonRow(
              theme,
              reason: e.key,
              count: e.value,
              percent: percent,
            );
          }).toList(),
        ],
      ),
    );
  }

  /// ✅ UI parts
  Widget _emptyCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "No critical failures detected in the last 7 days ✅",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 10,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Widget _header(ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.red.withOpacity(0.12),
          child: const Icon(Icons.warning_amber, color: Colors.red),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "Top Failure Reasons",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _worstLineChip(ThemeData theme, String line, int fails) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.factory, size: 20, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Worst Line: $line",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
          ),
          Text(
            "$fails fails",
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _failureReasonRow(
    ThemeData theme, {
    required String reason,
    required int count,
    required double percent,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  reason,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                "$count",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
