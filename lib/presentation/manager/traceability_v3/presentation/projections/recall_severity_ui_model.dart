// presentation/projections/recall_severity_ui_model.dart

import 'package:flutter/material.dart';
import '../../domain/services/recall_severity_service.dart';

/// ============================================================
/// 🎨 Recall Severity UI Model
/// ============================================================

class RecallSeverityUiModel {
  final RecallSeverity severity;
  final String label;
  final Color color;

  const RecallSeverityUiModel({
    required this.severity,
    required this.label,
    required this.color,
  });

  /// ============================================================
  /// 🔁 Mapper
  /// ============================================================

  static RecallSeverityUiModel fromSeverity(RecallSeverity severity) {
    switch (severity) {
      case RecallSeverity.low:
        return const RecallSeverityUiModel(
          severity: RecallSeverity.low,
          label: 'LOW RISK',
          color: Colors.green,
        );

      case RecallSeverity.medium:
        return const RecallSeverityUiModel(
          severity: RecallSeverity.medium,
          label: 'MEDIUM RISK',
          color: Colors.orange,
        );

      case RecallSeverity.high:
        return const RecallSeverityUiModel(
          severity: RecallSeverity.high,
          label: 'HIGH RISK',
          color: Colors.red,
        );
    }
  }
}
