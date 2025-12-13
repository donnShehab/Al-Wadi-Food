  import 'package:flutter/material.dart';

  class StaggeredFadeSlideItem extends StatelessWidget {
    final Widget child;
    final AnimationController controller;
    final int index;
    final double fromY;

    const StaggeredFadeSlideItem({
      super.key,
      required this.child,
      required this.controller,
      required this.index,
      this.fromY = 24,
    });

    @override
    Widget build(BuildContext context) {
      final animation = CurvedAnimation(
        parent: controller,
        curve: Interval(
          (index * 0.08).clamp(0.0, 1.0),
          1.0,
          curve: Curves.easeOutCubic,
        ),
      );

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, fromY / 100),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
    }
  }
