import '../../domain/services/recall_severity_service.dart';
import 'package:flutter/material.dart';

class RecallSeverityUI {
  final RecallSeverity severity;

  const RecallSeverityUI(this.severity);

  String get label {
    switch (severity) {
      case RecallSeverity.low:
        return 'LOW RISK';
      case RecallSeverity.medium:
        return 'MEDIUM RISK';
      case RecallSeverity.high:
        return 'HIGH RISK';
    }
  }

  Color get color {
    switch (severity) {
      case RecallSeverity.low:
        return Colors.green;
      case RecallSeverity.medium:
        return Colors.orange;
      case RecallSeverity.high:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (severity) {
      case RecallSeverity.low:
        return Icons.check_circle;
      case RecallSeverity.medium:
        return Icons.warning_amber;
      case RecallSeverity.high:
        return Icons.dangerous;
    }
  }
}
