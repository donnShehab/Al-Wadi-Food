// domain/services/recall_severity_service.dart

import '../models/recall_result_model.dart';

/// ============================================================
/// 🚨 Recall Severity
/// ============================================================

enum RecallSeverity { low, medium, high }

/// ============================================================
/// 🧠 Recall Severity Service
/// Business rules only — no UI, no Firestore
/// ============================================================

class RecallSeverityService {
  RecallSeverityService._(); // static-only

  /// Evaluate recall severity based on impact size & depth
  static RecallSeverity evaluate(RecallResultModel result) {
    final affectedCount = result.affectedNodes.length;
    final depth = result.maxDepth;

    /// 🔴 HIGH SEVERITY
    /// - Many affected nodes
    /// - Deep contamination spread
    if (affectedCount >= 10 || depth >= 5) {
      return RecallSeverity.high;
    }

    /// 🟠 MEDIUM SEVERITY
    /// - Moderate spread
    if (affectedCount >= 4 || depth >= 3) {
      return RecallSeverity.medium;
    }

    /// 🟢 LOW SEVERITY
    /// - Localized issue
    return RecallSeverity.low;
  }
}
