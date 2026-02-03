import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:flutter/material.dart';

class QCTopFailureReasonsCard extends StatelessWidget {
  final List<QCResultEntity> results;
  final VoidCallback? onViewBatches;

  const QCTopFailureReasonsCard({
    super.key,
    required this.results,
    this.onViewBatches,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final failureColor = theme.colorScheme.error;
    final failSoft = theme.colorScheme.error.withOpacity(0.10);

    final failedResults = results
        .where((r) => r.result == AppConstants.qcResultFail)
        .toList();

    if (failedResults.isEmpty) {
      return _emptyCard(theme);
    }

    // Group by failure reason
    final Map<String, int> reasonCount = {};
    for (final r in failedResults) {
      final reason = (r.failureReason ?? '').trim();
      final key = reason.isEmpty ? "Unknown" : reason;
      reasonCount[key] = (reasonCount[key] ?? 0) + 1;
    }

    final topReasons = reasonCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Worst line
    final Map<String, int> lineFails = {};
    for (final r in failedResults) {
      final line = (r.productionLine ?? '').trim();
      final key = line.isEmpty ? "Unknown Line" : line;
      lineFails[key] = (lineFails[key] ?? 0) + 1;
    }

    final worstLineEntry = lineFails.entries.isEmpty
        ? const MapEntry("Unknown Line", 0)
        : (lineFails.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .first;

    final maxCount = topReasons.isEmpty
        ? 1
        : topReasons.first.value.clamp(1, 999999);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: failSoft,
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: failureColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Top Failure Reasons",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Most repeated QC failures in the last 7 days",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: failSoft,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: failureColor.withOpacity(0.25)),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "${failedResults.length} fails",
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: failureColor,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Worst line banner + action
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: failSoft,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: failureColor.withOpacity(0.22)),
            ),
            child: Row(
              children: [
                Icon(Icons.factory_rounded, color: failureColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Worst Line: ${worstLineEntry.key}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // ✅ Action button (later you wire it)
                TextButton.icon(
                  onPressed: onViewBatches, // null => disabled
                  icon: const Icon(Icons.list_alt_rounded, size: 18),
                  label: const Text("View batches"),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                      side: BorderSide(
                        color: theme.colorScheme.primary.withOpacity(0.18),
                      ),
                    ),
                    backgroundColor: Colors.white.withOpacity(0.85),
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: failureColor.withOpacity(0.20)),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${worstLineEntry.value} fails",
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: failureColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Top reasons list (Top 3)
          ...topReasons.take(3).map((e) {
            final progress = (e.value / maxCount).clamp(0.0, 1.0);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          e.key,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${e.value}",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest
                          .withOpacity(0.8),
                      valueColor: AlwaysStoppedAnimation(failureColor),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _emptyCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.green.withOpacity(0.10),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "No failures recorded 🎉",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
