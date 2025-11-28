// ملف: core/widgets/fade_scale_animation_widget.dart

import 'package:flutter/material.dart';
import 'dart:async';

class FadeScaleAnimationWidget extends StatefulWidget {
  const FadeScaleAnimationWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.scaleStart = 0.5,
    this.scaleEnd = 1.0,
    this.curve = Curves.easeOutCubic,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final double scaleStart;
  final double scaleEnd;
  final Curve curve;

  @override
  State<FadeScaleAnimationWidget> createState() =>
      _FadeScaleAnimationWidgetState();
}

class _FadeScaleAnimationWidgetState extends State<FadeScaleAnimationWidget>
    with SingleTickerProviderStateMixin {
  // 💥 تصحيح: يجب تعريف المتغيرات هنا 💥
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // إعداد الـ Controller
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // 1. حركة التكبير (Scale)
    _scaleAnimation =
        Tween<double>(begin: widget.scaleStart, end: widget.scaleEnd).animate(
          CurvedAnimation(parent: _animationController, curve: widget.curve),
        );

    // 2. حركة التلاشي (Opacity) - تم إضافتها للتصحيح
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );

    // بدء الحركة بعد التأخير المطلوب
    Future.delayed(widget.delay, () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 💥 تصحيح: يجب استخدام كلتا الحركتين (Fade و Scale) في البناء
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
