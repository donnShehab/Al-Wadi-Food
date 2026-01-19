
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/entities/recall_impact_result.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/enums/trace_node_type.dart';

/// ============================================================
/// 🔒 Recall Auto-Lock Policy (Domain Logic)
/// ============================================================

class RecallLockPolicy {
  RecallLockPolicy._();

  /// Nodes that must be BLOCKED immediately
  static bool shouldAutoBlock(RecallImpactNode impact) {
    return impact.node.type == TraceNodeType.shipment ||
        impact.node.type == TraceNodeType.inventoryLot;
  }

  /// Returns nodeIds that should be blocked
  static Set<String> nodesToBlock(RecallImpactResult result) {
    return result.impacts
        .where(shouldAutoBlock)
        .map((i) => i.node.nodeId)
        .toSet();
  }
}
