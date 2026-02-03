import 'package:alwadi_food/presentation/animations/animated_number.dart';
import 'package:alwadi_food/presentation/animations/staggered_fade_slide_item.dart';
import 'package:flutter/material.dart';

class HomeStatsTiles extends StatelessWidget {
  final int total;
  final int passed;
  final int issues;

  const HomeStatsTiles({
    super.key,
    required this.total,
    required this.passed,
    required this.issues,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // UI-only: keep KPIs aligned with the system palette (executive).
    final totalColor = theme.colorScheme.primary;
    final passedColor = Colors.green.shade600;
    final issuesColor = Colors.redAccent.shade200;

    return Row(
      children: [
        Expanded(
          child: StaggeredSlideFade(
            index: 0,
            offsetY: 18,
            child: _StatTile(
              label: "Total Batches",
              value: total,
              color: totalColor,
              icon: Icons.inventory_2,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StaggeredSlideFade(
            index: 1,
            offsetY: 18,
            child: _StatTile(
              label: "Passed QC",
              value: passed,
              color: passedColor,
              icon: Icons.check_circle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StaggeredSlideFade(
            index: 2,
            offsetY: 18,
            child: _StatTile(
              label: "Issues",
              value: issues,
              color: issuesColor,
              icon: Icons.warning_amber_rounded,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final surface = theme.colorScheme.surface;
    final border = theme.colorScheme.onSurface.withOpacity(0.08);
    final tint = color.withOpacity(0.10);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(height: 8),
          _InteractiveNumber(value: value, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.85),
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractiveNumber extends StatefulWidget {
  final int value;
  final Color color;

  const _InteractiveNumber({required this.value, required this.color});

  @override
  State<_InteractiveNumber> createState() => _InteractiveNumberState();
}

class _InteractiveNumberState extends State<_InteractiveNumber> {
  bool _pressed = false;

  void _onTapDown(_) => setState(() => _pressed = true);
  void _onTapUp(_) => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOutBack,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 170),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _pressed ? widget.color.withOpacity(0.9) : widget.color,
          ),
          child: AnimatedNumber(value: widget.value),
        ),
      ),
    );
  }
}
