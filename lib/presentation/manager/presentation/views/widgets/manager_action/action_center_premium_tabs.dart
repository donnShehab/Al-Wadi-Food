import 'package:flutter/material.dart';

enum ActionCenterTab { pending, failed, approved, archived }

class ActionCenterCounts {
  final int pending;
  final int failed;
  final int approved;
  final int archived;

  const ActionCenterCounts({
    required this.pending,
    required this.failed,
    required this.approved,
    required this.archived,
  });

  int byTab(ActionCenterTab tab) {
    switch (tab) {
      case ActionCenterTab.pending:
        return pending;
      case ActionCenterTab.failed:
        return failed;
      case ActionCenterTab.approved:
        return approved;
      case ActionCenterTab.archived:
        return archived;
    }
  }
}

extension _TabUI on ActionCenterTab {
  String get label {
    switch (this) {
      case ActionCenterTab.pending:
        return "Pending";
      case ActionCenterTab.failed:
        return "Failed";
      case ActionCenterTab.approved:
        return "Approved";
      case ActionCenterTab.archived:
        return "Archived";
    }
  }

  IconData get icon {
    switch (this) {
      case ActionCenterTab.pending:
        return Icons.hourglass_bottom_rounded;
      case ActionCenterTab.failed:
        return Icons.cancel_rounded;
      case ActionCenterTab.approved:
        return Icons.verified_rounded;
      case ActionCenterTab.archived:
        return Icons.lock_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ActionCenterTab.pending:
        return Colors.orange;
      case ActionCenterTab.failed:
        return Colors.red;
      case ActionCenterTab.approved:
        return Colors.green;
      case ActionCenterTab.archived:
        return Colors.blueGrey;
    }
  }
}

/// ✅ Modern segmented slider:
/// - Grey rounded background
/// - Sliding white "active" pill with shadow
/// - Dot + Icon + Text + Count badge
class PremiumSegmentedTabs extends StatelessWidget {
  final ActionCenterTab selected;
  final ActionCenterCounts counts;
  final ValueChanged<ActionCenterTab> onChanged;

  const PremiumSegmentedTabs({
    super.key,
    required this.selected,
    required this.counts,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF1F2F4);

    return LayoutBuilder(
      builder: (context, c) {
        final tabs = ActionCenterTab.values;
        final w = c.maxWidth;
        final itemW = w / tabs.length;

        final selectedIndex = tabs.indexOf(selected);

        return Container(
          height: 50,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black.withOpacity(0.04)),
          ),
          child: Stack(
            children: [
              // ✅ Sliding active pill
              AnimatedPositioned(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                left: selectedIndex * itemW,
                top: 0,
                bottom: 0,
                width: itemW,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                ),
              ),

              Row(
                children: tabs.map((t) {
                  final isActive = t == selected;
                  final count = counts.byTab(t);

                  return Expanded(
                    child: InkWell(
                      onTap: () => onChanged(t),
                      borderRadius: BorderRadius.circular(14),
                      child: Center(
                        child: _TabItem(
                          tab: t,
                          count: count,
                          active: isActive,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  final ActionCenterTab tab;
  final int count;
  final bool active;

  const _TabItem({
    required this.tab,
    required this.count,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = tab.color;
    final textColor = active ? Colors.black : Colors.black.withOpacity(0.55);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ✅ small colored dot
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),

        Icon(tab.icon, size: 16, color: dotColor),
        const SizedBox(width: 6),

        Text(
          tab.label,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 12.5,
            color: textColor,
            letterSpacing: -0.2,
          ),
        ),

        const SizedBox(width: 6),

        // ✅ subtle count badge
        if (count > 0)
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(active ? 0.06 : 0.035),
              shape: BoxShape.circle,
            ),
            child: Text(
              "$count",
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                color: Colors.black.withOpacity(active ? 0.8 : 0.55),
              ),
            ),
          ),
      ],
    );
  }
}
