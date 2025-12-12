import 'package:flutter/material.dart';

class BreathingCard extends StatefulWidget {
  final Widget child;

  const BreathingCard({super.key, required this.child});

  @override
  State<BreathingCard> createState() => _BreathingCardState();
}

class _BreathingCardState extends State<BreathingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _shadow;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), // بطيئة جدًا
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 1.0,
      end: 1.015, // فرق صغير جدًا
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _shadow = Tween<double>(
      begin: 0.18,
      end: 0.28,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_shadow.value),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
