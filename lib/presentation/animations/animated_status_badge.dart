import 'package:flutter/material.dart';

class AnimatedStatusBadge extends StatefulWidget {
  final String status;
  final Color color;
  final bool enableAnimation;

  const AnimatedStatusBadge({
    super.key,
    required this.status,
    required this.color,
    this.enableAnimation = true,
  });

  @override
  State<AnimatedStatusBadge> createState() => _AnimatedStatusBadgeState();
}

class _AnimatedStatusBadgeState extends State<AnimatedStatusBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glow = Tween<double>(
      begin: 0.2,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAnimated = widget.enableAnimation;

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.color.withOpacity(0.15),
        border: Border.all(color: widget.color, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: widget.color.withOpacity(_glow.value),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        widget.status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          color: widget.color,
          fontWeight: FontWeight.w800,
          fontSize: 11,
          letterSpacing: 0.6,
        ),
      ),
    );

    if (!isAnimated) return badge;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.scale(scale: _scale.value, child: badge);
      },
    );
  }
}
