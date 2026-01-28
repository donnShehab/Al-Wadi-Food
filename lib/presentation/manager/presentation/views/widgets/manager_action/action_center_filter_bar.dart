import 'dart:ui';
import 'package:flutter/material.dart';

enum ActionCenterFilter { pending, failed, approved, highRisk, archived }

class ActionCenterCounts {
  final int pending;
  final int failed;
  final int approved;
  final int highRisk;
  final int archived;

  const ActionCenterCounts({
    required this.pending,
    required this.failed,
    required this.approved,
    required this.highRisk,
    required this.archived,
  });

  int byFilter(ActionCenterFilter f) {
    switch (f) {
      case ActionCenterFilter.pending:
        return pending;
      case ActionCenterFilter.failed:
        return failed;
      case ActionCenterFilter.approved:
        return approved;
      case ActionCenterFilter.highRisk:
        return highRisk;
      case ActionCenterFilter.archived:
        return archived;
    }
  }
}

extension _FilterUI on ActionCenterFilter {
  String get label {
    switch (this) {
      case ActionCenterFilter.pending:
        return "Pending";
      case ActionCenterFilter.failed:
        return "Failed";
      case ActionCenterFilter.approved:
        return "Approved";
      case ActionCenterFilter.highRisk:
        return "High Risk";
      case ActionCenterFilter.archived:
        return "Archived";
    }
  }

  IconData get icon {
    switch (this) {
      case ActionCenterFilter.pending:
        return Icons.hourglass_bottom_rounded;
      case ActionCenterFilter.failed:
        return Icons.cancel_rounded;
      case ActionCenterFilter.approved:
        return Icons.verified_rounded;
      case ActionCenterFilter.highRisk:
        return Icons.warning_rounded;
      case ActionCenterFilter.archived:
        return Icons.lock_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ActionCenterFilter.pending:
        return Colors.orange;
      case ActionCenterFilter.failed:
        return Colors.red;
      case ActionCenterFilter.approved:
        return Colors.green;
      case ActionCenterFilter.highRisk:
        return Colors.deepOrange;
      case ActionCenterFilter.archived:
        return Colors.blueGrey;
    }
  }
}

/// ✅ Premium “Filter Chips Gallery”
/// - Horizontal scroll
/// - Glassmorphism
/// - Selected chip grows + glow
class ActionCenterFilterBar extends StatelessWidget {
  final ActionCenterFilter selected;
  final ActionCenterCounts counts;
  final ValueChanged<ActionCenterFilter> onChanged;

  const ActionCenterFilterBar({
    super.key,
    required this.selected,
    required this.counts,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ActionCenterFilter.values;

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemBuilder: (context, i) {
          final f = filters[i];
          final active = f == selected;
          final count = counts.byFilter(f);

          return _PremiumFilterChip(
            label: f.label,
            icon: f.icon,
            color: f.color,
            count: count,
            active: active,
            onTap: () => onChanged(f),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: filters.length,
      ),
    );
  }
}

class _PremiumFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int count;
  final bool active;
  final VoidCallback onTap;

  const _PremiumFilterChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.count,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scale = active ? 1.05 : 1.0;

    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      scale: scale,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // glow
            if (active)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.22),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ),

            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? color.withOpacity(0.14)
                        : Colors.white.withOpacity(0.72),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: active
                          ? color.withOpacity(0.40)
                          : Colors.black.withOpacity(0.06),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(active ? 0.10 : 0.06),
                        blurRadius: active ? 16 : 10,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(icon, size: 18, color: color),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: Colors.black.withOpacity(active ? 0.92 : 0.70),
                        ),
                      ),
                      if (count > 0) ...[
                        const SizedBox(width: 10),
                        _CountBadge(
                          value: count,
                          active: active,
                          accent: color,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Optional floating badge look (uncomment if you want it above)
            // if (count > 0)
            //   Positioned(
            //     top: -6,
            //     right: -6,
            //     child: _FloatingBadge(value: count, accent: color),
            //   ),
          ],
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int value;
  final bool active;
  final Color accent;

  const _CountBadge({
    required this.value,
    required this.active,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: active
            ? accent.withOpacity(0.18)
            : Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        "$value",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: Colors.black.withOpacity(active ? 0.85 : 0.65),
        ),
      ),
    );
  }
}

// Optional floating badge (if you want)
class _FloatingBadge extends StatelessWidget {
  final int value;
  final Color accent;

  const _FloatingBadge({required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.30),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Text(
        "$value",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 11,
        ),
      ),
    );
  }
}
