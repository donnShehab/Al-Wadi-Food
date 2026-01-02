import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/manager_trend_day_entity.dart';
import 'manager_trend_chip.dart';

class ManagerTrendSummaryRow extends StatelessWidget {
  final List<ManagerTrendDayEntity> trend;

  const ManagerTrendSummaryRow({super.key, required this.trend});

  String _dayLabel(DateTime d) {
    const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return days[d.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    if (trend.isEmpty) return const SizedBox();

    // ✅ Total inspections this week
    final totalInspections = trend.fold<int>(
      0,
      (sum, d) => sum + d.passed + d.failed,
    );

    // ✅ Average pass rate
    final totalPassed = trend.fold<int>(0, (sum, d) => sum + d.passed);
    final avgPassRate = totalInspections == 0
        ? 0.0
        : (totalPassed / totalInspections) * 100;

    // ✅ Best day = max passed
    final bestDay = trend.reduce((a, b) => a.passed >= b.passed ? a : b);

    // ✅ Worst day = max failed
    final worstDay = trend.reduce((a, b) => a.failed >= b.failed ? a : b);

    return Column(
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ManagerTrendChip(
              icon: Icons.emoji_events_rounded,
              title: "Best Day",
              value: "${_dayLabel(bestDay.day)} (${bestDay.passed} PASS)",
              color: Colors.green,
            ),
            ManagerTrendChip(
              icon: Icons.warning_amber_rounded,
              title: "Worst Day",
              value: "${_dayLabel(worstDay.day)} (${worstDay.failed} FAIL)",
              color: Colors.red,
            ),
            ManagerTrendChip(
              icon: Icons.analytics_rounded,
              title: "Total",
              value: "$totalInspections Inspections",
              color: Colors.blueGrey,
            ),
            ManagerTrendChip(
              icon: Icons.check_circle_rounded,
              title: "Avg Pass",
              value: "${avgPassRate.toStringAsFixed(1)}%",
              color: Colors.teal,
            ),
          ],
        ),

        const SizedBox(height: 14),

        // ✅ Tiny insight row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.withOpacity(0.12)),
          ),
          child: Row(
            children: [
              const Icon(Icons.insights_rounded, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  totalInspections == 0
                      ? "No inspections recorded this week yet."
                      : "Best performance was on ${_dayLabel(bestDay.day)} with ${bestDay.passed} PASS. Focus on ${_dayLabel(worstDay.day)} (highest FAIL).",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
