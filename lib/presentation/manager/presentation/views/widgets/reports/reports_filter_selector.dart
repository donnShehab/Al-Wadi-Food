import 'package:alwadi_food/presentation/manager/presentation/views/widgets/reports/reports_center_firestore_ds.dart';
import 'package:flutter/material.dart';

class ReportsFilterSelector extends StatelessWidget {
  final ReportsRange selected;
  final Function(ReportsRange) onChanged;

  const ReportsFilterSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  String _label(ReportsRange r) {
    switch (r) {
      case ReportsRange.today:
        return "Today";
      case ReportsRange.week:
        return "Last 7 Days";
      case ReportsRange.month:
        return "Last Month";
    }
  }

  IconData _icon(ReportsRange r) {
    switch (r) {
      case ReportsRange.today:
        return Icons.today_rounded;
      case ReportsRange.week:
        return Icons.date_range_rounded;
      case ReportsRange.month:
        return Icons.calendar_month_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: ReportsRange.values.map((r) {
          final isActive = r == selected;

          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onChanged(r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                padding: const EdgeInsets.symmetric(vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive ? scheme.primary : scheme.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _icon(r),
                      size: 18,
                      color: isActive ? Colors.white : scheme.onSurface,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _label(r),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: isActive ? Colors.white : scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
