import 'package:flutter/material.dart';

class AnimatedNumber extends StatelessWidget {
  final int value;
  final Duration duration;
  final Curve curve;

  const AnimatedNumber({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 1200),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: curve,
      builder: (context, animatedValue, _) {
        return Text(animatedValue.toInt().toString(), );
      },
    );
  }
}
