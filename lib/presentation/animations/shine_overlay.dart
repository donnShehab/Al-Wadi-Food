import 'package:flutter/material.dart';

class ShineOverlay extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const ShineOverlay({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 3400), // أبطأ و أهدأ
  });

  @override
  State<ShineOverlay> createState() => _ShineOverlayState();
}

class _ShineOverlayState extends State<ShineOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _position;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    // حركة اللمعة
    _position = Tween<double>(begin: -1.2, end:1.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    // Fade in → Fade out
    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.22), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.22, end: 0.22), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.22, end: 0.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

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
    return Stack(
      children: [
        widget.child,

        /// ✨ Shine layer
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Opacity(
                  opacity: _opacity.value,
                  child: FractionalTranslation(
                    translation: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: -0.35,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.35),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
