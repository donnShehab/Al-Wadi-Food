import 'package:flutter/material.dart';
import '../../application/services/recall_severity.dart';

/// ============================================================
/// 🚨 Severity Badge (Manager Visual Indicator)
/// ============================================================
class SeverityBadge extends StatelessWidget {
  final RecallSeverity severity;

  const SeverityBadge({super.key, required this.severity});

  Color get _color {
    switch (severity) {
      case RecallSeverity.low:
        return Colors.green;
      case RecallSeverity.medium:
        return Colors.orange;
      case RecallSeverity.critical:
        return Colors.red;
    }
  }

  String get _label {
    switch (severity) {
      case RecallSeverity.low:
        return 'LOW RISK';
      case RecallSeverity.medium:
        return 'MEDIUM RISK';
      case RecallSeverity.critical:
        return 'CRITICAL RECALL';
    }
  }

  IconData get _icon {
    switch (severity) {
      case RecallSeverity.low:
        return Icons.check_circle;
      case RecallSeverity.medium:
        return Icons.warning_amber_rounded;
      case RecallSeverity.critical:
        return Icons.dangerous;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: _color),
          const SizedBox(width: 8),
          Text(
            _label,
            style: TextStyle(
              color: _color,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
