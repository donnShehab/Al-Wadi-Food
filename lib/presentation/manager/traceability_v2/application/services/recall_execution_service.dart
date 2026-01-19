import 'package:alwadi_food/presentation/manager/traceability_v2/domain/entities/recall_impact_result.dart';

import 'recall_severity.dart';
import 'recall_lock_policy.dart';

/// ============================================================
/// 🧑‍💼 Recall Execution Decision (Manager Action)
/// ============================================================

class RecallExecutionPlan {
  final RecallSeverity severity;
  final Set<String> nodeIdsToLock;

  const RecallExecutionPlan({
    required this.severity,
    required this.nodeIdsToLock,
  });
}

/// ============================================================
/// 🧠 Recall Execution Service
/// ============================================================

class RecallExecutionService {
  RecallExecutionService._();

  static RecallExecutionPlan prepareExecution(RecallImpactResult result) {
    final severity = RecallSeverityEngine.evaluate(result);
    final nodesToLock = RecallLockPolicy.nodesToBlock(result);

    return RecallExecutionPlan(severity: severity, nodeIdsToLock: nodesToLock);
  }
}
