import 'package:flutter/material.dart';

class StaggeredSlideFade extends StatefulWidget {
  final int index;
  final Widget child;

  final Duration duration;
  final Duration delay; // ✅ جديد (اختياري)
  final double offsetX;
  final double offsetY;

  const StaggeredSlideFade({
    super.key,
    required this.index,
    required this.child,
    this.duration = const Duration(milliseconds: 650),
    this.delay = Duration.zero, // ✅ افتراضي: بدون تأخير (حتى ما نكسر أي مكان)
    this.offsetX = 0,
    this.offsetY = 22,
  });

  @override
  State<StaggeredSlideFade> createState() => _StaggeredSlideFadeState();
}

class _StaggeredSlideFadeState extends State<StaggeredSlideFade> {
  bool _play = false;

  @override
  void initState() {
    super.initState();

    // ✅ نبدأ الأنيميشن بعد delay
    Future.delayed(widget.delay, () {
      if (!mounted) return;
      setState(() => _play = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    // قبل التشغيل: نخليه مخفي ومزاح شوي
    if (!_play) {
      return Opacity(
        opacity: 0,
        child: Transform.translate(
          offset: Offset(widget.offsetX, widget.offsetY),
          child: Transform.scale(scale: 0.96, child: widget.child),
        ),
      );
    }

    // بعد التشغيل: TweenAnimationBuilder طبيعي (بدون delay)
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: Offset(widget.offsetX * (1 - v), widget.offsetY * (1 - v)),
            child: Transform.scale(
              scale: 0.96 + (0.04 * v),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
