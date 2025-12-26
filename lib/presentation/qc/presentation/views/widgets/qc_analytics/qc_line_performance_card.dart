import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';

class QCLinePerformanceCard extends StatelessWidget {
  final List<QCResultEntity> results;

  const QCLinePerformanceCard({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    /// ✅ last 7 days only
    final lastWeek = results.where((r) => r.createdAt.isAfter(sevenDaysAgo));

    if (lastWeek.isEmpty) {
      return const SizedBox();
    }

    /// ✅ group by production line
    final Map<String, List<QCResultEntity>> byLine = {};
    for (final r in lastWeek) {
      final line = r.productionLine.isEmpty ? "Unknown" : r.productionLine;
      byLine.putIfAbsent(line, () => []);
      byLine[line]!.add(r);
    }

    /// ✅ convert to summary list
    final summaries = byLine.entries.map((entry) {
      final line = entry.key;
      final lineResults = entry.value;

      final passed = lineResults
          .where((e) => e.result == AppConstants.qcResultPass)
          .length;

      final failed = lineResults
          .where((e) => e.result == AppConstants.qcResultFail)
          .length;

      final total = passed + failed;
      final passRate = total == 0 ? 0 : ((passed / total) * 100).round();

      return _LineSummary(
        line: line,
        total: total,
        passed: passed,
        failed: failed,
        passRate: passRate,
      );
    }).toList();

    /// ✅ sort worst first (low pass rate)
    summaries.sort((a, b) => a.passRate.compareTo(b.passRate));

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ✅ Header
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                child: Icon(Icons.factory, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Performance by Line",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            "Weekly pass rate comparison across production lines",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 18),

          ...summaries.map((s) => _lineRow(theme, s)).toList(),
        ],
      ),
    );
  }

  Widget _lineRow(ThemeData theme, _LineSummary s) {
    final Color color = s.passRate >= 85
        ? Colors.green
        : (s.passRate >= 70 ? Colors.orange : Colors.red);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              s.line,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${s.passRate}%",
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${s.failed}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Chip(
              label: Text(
                s.passRate >= 85
                    ? "GOOD"
                    : (s.passRate >= 70 ? "WATCH" : "RISK"),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class _LineSummary {
  final String line;
  final int total;
  final int passed;
  final int failed;
  final int passRate;

  _LineSummary({
    required this.line,
    required this.total,
    required this.passed,
    required this.failed,
    required this.passRate,
  });
}
