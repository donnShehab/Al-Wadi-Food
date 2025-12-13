import 'package:flutter/material.dart';

class StaggeredSlideFade extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration duration;
  final double offsetX;
  final double offsetY;

  const StaggeredSlideFade({
    super.key,
    required this.index,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.offsetX = 0,
    this.offsetY = 22,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(offsetX * (1 - v), offsetY * (1 - v)),
            child: Transform.scale(scale: 0.96 + (0.04 * v), child: child),
          ),
        );
      },
    );
  }
}
