import 'package:flutter/material.dart';
class FadeSlide extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final double fromY;

  const FadeSlide({
    super.key,
    required this.child,
    required this.animation,
    this.fromY = 20,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final value = animation.value.clamp(0.0, 1.0);

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * fromY),
            child: child,
          ),
        );
      },
    );
  }
}
