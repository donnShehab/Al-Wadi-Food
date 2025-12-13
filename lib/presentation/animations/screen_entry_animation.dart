import 'package:flutter/material.dart';

class ScreenEntryAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset beginOffset;

  const ScreenEntryAnimation({
    super.key,
    required this.child,
  this.duration = const Duration(seconds: 2),
    this.beginOffset = const Offset(0, 1),

  });

  @override
  State<ScreenEntryAnimation> createState() => _ScreenEntryAnimationState();
}

class _ScreenEntryAnimationState extends State<ScreenEntryAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
