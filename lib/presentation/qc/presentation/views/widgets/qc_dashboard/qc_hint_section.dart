import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_hint_card.dart';
import 'package:flutter/material.dart';

class QCHintSection extends StatelessWidget {
  const QCHintSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const QCHintCard(
      text:
          "⚠️ Inspections should be completed quickly to prevent production delays and ensure compliance.",
    );
  }
}
