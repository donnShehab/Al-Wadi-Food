import 'package:flutter/material.dart';

class SoftHighlightCard extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const SoftHighlightCard({
    super.key,
    required this.child,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final scale = Tween<double>(begin: 1.0, end: 1.02).animate(animation);
    final shadow = Tween<double>(begin: 0.10, end: 0.25).animate(animation);

    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        return Transform.scale(
          scale: scale.value,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(shadow.value),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
