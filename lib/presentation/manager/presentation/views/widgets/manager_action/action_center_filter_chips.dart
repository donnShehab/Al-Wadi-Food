import 'dart:ui';
import 'package:flutter/material.dart';

enum ActionCenterFilter { pending, failed, approved, highRisk, archived }

class ActionCenterFilterChips extends StatelessWidget {
  final ActionCenterFilter selected;
  final ValueChanged<ActionCenterFilter> onChanged;

  final int pendingCount;
  final int failedCount;
  final int approvedCount;
  final int highRiskCount;
  final int archivedCount;

  const ActionCenterFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.pendingCount,
    required this.failedCount,
    required this.approvedCount,
    required this.highRiskCount,
    required this.archivedCount,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_ChipSpec>[
      _ChipSpec(
        filter: ActionCenterFilter.pending,
        label: "Pending",
        icon: Icons.hourglass_bottom_rounded,
        color: Colors.amber,
        count: pendingCount,
      ),
      _ChipSpec(
        filter: ActionCenterFilter.failed,
        label: "Failed",
        icon: Icons.cancel_rounded,
        color: Colors.red,
        count: failedCount,
      ),
      _ChipSpec(
        filter: ActionCenterFilter.approved,
        label: "Approved",
        icon: Icons.verified_rounded,
        color: Colors.green,
        count: approvedCount,
      ),
      _ChipSpec(
        filter: ActionCenterFilter.highRisk,
        label: "High Risk",
        icon: Icons.warning_amber_rounded,
        color: Colors.orange,
        count: highRiskCount,
      ),
      _ChipSpec(
        filter: ActionCenterFilter.archived,
        label: "Archived",
        icon: Icons.lock_rounded,
        color: Colors.blueGrey,
        count: archivedCount,
      ),
    ];

    return SizedBox(
      height: 58,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final spec = items[index];
          final isSelected = selected == spec.filter;
          return Padding(
            padding: EdgeInsets.only(right: index == items.length - 1 ? 0 : 10),
            child: _PremiumChip(
              spec: spec,
              selected: isSelected,
              onTap: () => onChanged(spec.filter),
            ),
          );
        },
      ),
    );
  }
}

class _ChipSpec {
  final ActionCenterFilter filter;
  final String label;
  final IconData icon;
  final Color color;
  final int count;

  _ChipSpec({
    required this.filter,
    required this.label,
    required this.icon,
    required this.color,
    required this.count,
  });
}

class _PremiumChip extends StatelessWidget {
  final _ChipSpec spec;
  final bool selected;
  final VoidCallback onTap;

  const _PremiumChip({
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? spec.color.withOpacity(0.14)
        : Colors.white.withOpacity(0.72);
    final border = selected
        ? spec.color.withOpacity(0.35)
        : Colors.black.withOpacity(0.06);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: selected ? 1.06 : 1.0),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: border),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: spec.color.withOpacity(0.25),
                          blurRadius: 18,
                          spreadRadius: 1,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 14,
                          offset: const Offset(0, 10),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // dot
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: spec.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),

                  Icon(
                    spec.icon,
                    size: 16,
                    color: selected ? spec.color : Colors.black87,
                  ),
                  const SizedBox(width: 8),

                  Text(
                    spec.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12.5,
                      color: selected ? Colors.black : Colors.black87,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 10),

                  _CountBadge(
                    count: spec.count,
                    color: spec.color,
                    selected: selected,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  final Color color;
  final bool selected;

  const _CountBadge({
    required this.count,
    required this.color,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final c = selected ? color : Colors.black54;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(selected ? 0.18 : 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(0.20)),
      ),
      child: Text(
        "$count",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: c),
      ),
    );
  }
}
