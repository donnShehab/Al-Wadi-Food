import 'dart:ui' as ui;
import 'package:alwadi_food/presentation/widgets/brand/alwadi_icon.dart';
import 'package:flutter/material.dart';

/// ============================
///  ALWADI SPLASH VIEW BODY
/// ============================
/// Timeline (~5.0s, slow & deliberate):
///
/// 0   → 400 ms : شاشة بيضاء بالكامل (لا شيء ظاهر).
/// 400 → 1700 ms: Phase 1 – الوادي & Alwadi slide to center (1.3s).
/// 1700 → 2100 : Pause (البراند ثابت في النص).
/// 2100 → 2600 : Phase 2 – tagline fade-in (0.5s).
/// 2600 → 2900 : Pause خفيفة (0.3s).
/// 2900 → 3600 : Phase 3 – icon drops من أعلى الشاشة إلى فوق النص (0.7s، بطيئة وواضحة).
/// 3600 → 4200 : Pause فوق النص (0.6s).
/// 4200 → 5000 : Phase 4 – icon falls down خارج الشاشة (0.8s بطيئة)،
///               وفي نفس اللحظة onAnimationComplete() → نروح لصفحة تسجيل الدخول.
///
/// Total duration: 5000ms.

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key, required this.onAnimationComplete});

  /// يتم استدعاؤه مرة واحدة عندما ينتهي الأنيميشن بالكامل (بعد Phase 4).
  final VoidCallback onAnimationComplete;

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _callbackCalled = false;

  // ==================== TIMINGS (ms) ====================
  static const int _pureWhiteEndMs = 400; // 0.4s – بداية ظهور البراند

  // Phase 1: brand convergence 0.4s → 1.7s (1.3s)
  static const int _brandStartMs = 400;
  static const int _brandEndMs = 1700;

  // Pause بعد البراند: 1.7s → 2.1s (0.4s تقريباً)

  // Phase 2: tagline fade-in: 2.1s → 2.6s (0.5s)
  static const int _taglineFadeStartMs = 2100;
  static const int _taglineFadeEndMs = 2600;

  // Pause خفيفة: 2.6s → 2.9s (0.3s)

  // Phase 3: icon drop from top to above text: 2.9s → 3.6s (0.7s أبطأ)
  static const int _iconDropStartMs = 2900;
  static const int _iconDropEndMs = 3600;

  // Pause فوق النص: 3.6s → 4.2s (0.6s)

  // Phase 4: icon exit to bottom: 4.2s → 5.0s (0.8s بطيئة وواضحة)
  static const int _iconExitStartMs = 4200;
  static const int _iconExitEndMs = 4900;

  static const int _totalDurationMs = _iconExitEndMs;

  static const Color _backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: _totalDurationMs),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed &&
              !_callbackCalled &&
              mounted) {
            _callbackCalled = true;

            // 🔥 انتظر 200ms بعد ما الأيقونة تخلص نزولها تحت
            // ثم استدعِ onAnimationComplete → ومنها يروح للـ Login
            Future.delayed(const Duration(microseconds: 60), () {
              if (!mounted) return;
              widget.onAnimationComplete();
            });
          }
        });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final double t = _controller.value; // 0 → 1
          final double timeMs = t * _totalDurationMs; // التوقيت الحالي بالـ ms

          // ================== PHASE 1: تقارب الكلمات ==================

          final double brandProgress = _segmentProgress(
            timeMs,
            _brandStartMs.toDouble(),
            _brandEndMs.toDouble(),
          );

          final double arabicEase = Curves.easeInOutCubic.transform(
            brandProgress,
          );
          final double arabicDx =
              ui.lerpDouble(size.width * 0.4, 0.0, arabicEase) ?? 0.0;

          final double englishEase = Curves.easeInOutCubic.transform(
            brandProgress,
          );
          final double englishDx =
              ui.lerpDouble(-size.width * 0.4, 0.0, englishEase) ?? 0.0;

          final double textOpacity = Curves.easeInOutCubic.transform(
            brandProgress,
          );

          // ================== PHASE 2: التاغلاين ==================

          final double taglineSegment = _segmentProgress(
            timeMs,
            _taglineFadeStartMs.toDouble(),
            _taglineFadeEndMs.toDouble(),
          );
          final double taglineOpacity = Curves.easeInOutCubic.transform(
            taglineSegment,
          );

          // ================== PHASE 3 + 4: الأيقونة ==================

          double iconOffsetY = 0.0;
          double iconOpacity = 0.0;

          // Phase 3: نزول من أعلى الشاشة إلى مكان ثابت فوق النص
          final double iconDropSegment = _segmentProgress(
            timeMs,
            _iconDropStartMs.toDouble(),
            _iconDropEndMs.toDouble(),
          );
          if (iconDropSegment > 0.0) {
            iconOpacity = 1.0;
            final double iconDropEase = Curves.easeInOutCubic.transform(
              iconDropSegment,
            );
            iconOffsetY =
                ui.lerpDouble(-size.height * 0.3, 0.0, iconDropEase) ?? 0.0;
          }

          // Phase 4: نزول إضافي لأسفل الشاشة (خروج كامل وبطيء)
          final double iconExitSegment = _segmentProgress(
            timeMs,
            _iconExitStartMs.toDouble(),
            _iconExitEndMs.toDouble(),
          );
          if (iconExitSegment > 0.0) {
            final double iconExitEase = Curves.easeInOutCubic.transform(
              iconExitSegment,
            );
            // من 0 → ارتفاع الشاشة كامل؛ عند النهاية تكون الأيقونة تحت تماماً
            final double extraDrop =
                ui.lerpDouble(0.0, size.height, iconExitEase) ?? 0.0;
            iconOffsetY += extraDrop;
          }

          return Container(
            color: _backgroundColor,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Icon (snowflake / brand mark)
                  Opacity(
                    opacity: iconOpacity,
                    child: Transform.translate(
                      offset: Offset(0, iconOffsetY),
                      child: const AlwadiIcon(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Brand + tagline block
                  Center(
                    child: Opacity(
                      opacity: textOpacity,
                      child: _BrandLockup(
                        arabicDx: arabicDx,
                        englishDx: englishDx,
                        taglineOpacity: taglineOpacity,
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ====================== SUB-WIDGETS ======================



class _BrandLockup extends StatelessWidget {
  const _BrandLockup({
    required this.arabicDx,
    required this.englishDx,
    required this.taglineOpacity,
  });

  final double arabicDx;
  final double englishDx;
  final double taglineOpacity;

  static const Color _brandNavy = Color(0xFF1F2933);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final arabicStyle =
        theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: _brandNavy,
          fontSize: 22,
          fontFamilyFallback: const ['Cairo', 'Noto Sans Arabic'],
        ) ??
        const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _brandNavy,
        );

    final englishStyle =
        theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: _brandNavy,
          letterSpacing: 0.6,
        ) ??
        const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _brandNavy,
          letterSpacing: 0.6,
        );

    final taglineStyle =
        theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: _brandNavy.withOpacity(0.75),
          letterSpacing: 0.4,
        ) ??
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _brandNavy.withOpacity(0.75),
          letterSpacing: 0.4,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.translate(
          offset: Offset(arabicDx, 0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('الوادي', style: arabicStyle),
          ),
        ),
        const SizedBox(height: 4),
        Transform.translate(
          offset: Offset(englishDx, 0),
          child: Text('Alwadi', style: englishStyle),
        ),
        const SizedBox(height: 2),
        Opacity(
          opacity: taglineOpacity,
          child: Text(
            'Food Production & QC Management',
            style: taglineStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// يحوّل الوقت الحالي داخل Segment إلى قيمة 0 → 1
double _segmentProgress(double currentMs, double startMs, double endMs) {
  if (currentMs <= startMs) return 0.0;
  if (currentMs >= endMs) return 1.0;
  return (currentMs - startMs) / (endMs - startMs);
}
