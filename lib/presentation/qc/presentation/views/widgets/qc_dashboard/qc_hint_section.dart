import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_hint_card.dart';
import 'package:flutter/material.dart';

class QCHintSection extends StatelessWidget {
  const QCHintSection({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        final dy = (1 - t) * 8;
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, dy), child: child),
        );
      },
      child: const QCHintCard(
        text:
            "⚠️ Inspections should be completed quickly to prevent production delays and ensure compliance.",
      ),
    );
  }
}
