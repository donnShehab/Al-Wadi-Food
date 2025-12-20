import 'package:flutter/material.dart';
import 'qc_risk_evaluator.dart';

class QCRiskBadge extends StatelessWidget {
  final QCRiskLevel level;

  const QCRiskBadge({super.key, required this.level});

  Color get _color {
    switch (level) {
      case QCRiskLevel.low:
        return Colors.green;
      case QCRiskLevel.medium:
        return Colors.orange;
      case QCRiskLevel.high:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color),
      ),
      child: Text(
        QCRiskEvaluator.label(level),
        style: TextStyle(color: _color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
