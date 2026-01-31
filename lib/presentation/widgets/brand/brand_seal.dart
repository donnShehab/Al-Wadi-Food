import 'dart:ui';
import 'package:flutter/material.dart';

/// A premium "brand seal" container (glass + hairline border).
/// Designed to make a logo feel integrated and executive.
class BrandSeal extends StatelessWidget {
  const BrandSeal({
    super.key,
    required this.child,
    this.size = 80,
    this.heroTag,
    this.tint,
    this.paddingFactor = 0.18,
  });

  /// The logo widget (Image.asset, Icon, etc.)
  final Widget child;

  /// Outer size of the seal.
  final double size;

  /// Optional Hero tag to enable seamless transitions across routes.
  final String? heroTag;

  /// Optional tint for monochrome usage (future-ready).
  final Color? tint;

  /// Inner padding as a percentage of size.
  final double paddingFactor;

  @override
  Widget build(BuildContext context) {
    final navy = Theme.of(context).colorScheme.primary;

    Widget content = SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Glass layer
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(color: Colors.white.withOpacity(0.58)),
            ),

            // Subtle inner highlight
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: size * 0.45,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.60),
                      Colors.white.withOpacity(0.00),
                    ],
                  ),
                ),
              ),
            ),

            // Hairline border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: navy.withOpacity(0.14), width: 1),
              ),
            ),

            // Logo content
            Padding(
              padding: EdgeInsets.all(size * paddingFactor),
              child: tint == null
                  ? child
                  : ColorFiltered(
                      colorFilter: ColorFilter.mode(tint!, BlendMode.srcIn),
                      child: child,
                    ),
            ),
          ],
        ),
      ),
    );

    if (heroTag != null) {
      content = Hero(tag: heroTag!, child: content);
    }

    return content;
  }
}
