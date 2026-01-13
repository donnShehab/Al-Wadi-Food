import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';

import '../../utils/trace_alert_filters.dart';

class TraceAlertFilterChips extends StatelessWidget {
  final String selected;
  final Map<String, int> counts;
  final ValueChanged<String> onSelected;

  const TraceAlertFilterChips({
    super.key,
    required this.selected,
    required this.counts,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_ChipItem>[
      _ChipItem(TraceAlertFilters.all, 'All'),
      _ChipItem(TraceAlertFilters.critical, 'Critical'),
      _ChipItem(TraceAlertFilters.evidence, 'Evidence'),
      _ChipItem(TraceAlertFilters.sla, 'SLA'),
      _ChipItem(TraceAlertFilters.ready, 'Ready'),
      _ChipItem(TraceAlertFilters.reviewed, 'Reviewed'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((it) {
        final count = counts[it.key] ?? 0;
        final isSelected = selected == it.key;

        return ChoiceChip(
          selected: isSelected,
          label: Text("${it.label} ($count)"),
          labelStyle: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
          onSelected: (_) => onSelected(it.key),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        );
      }).toList(),
    );
  }
}

class _ChipItem {
  final String key;
  final String label;
  _ChipItem(this.key, this.label);
}
