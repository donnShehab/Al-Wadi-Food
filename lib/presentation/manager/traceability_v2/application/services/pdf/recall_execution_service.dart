
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/entities/recall_impact_result.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/enums/trace_node_type.dart';

/// ============================================================
/// 🔐 Recall Execution Service
/// Prepares node status updates for Firestore
/// ============================================================
class RecallExecutionService {
  /// Returns: nodeId → newStatus
  Map<String, String> prepareLocks(RecallImpactResult impact) {
    final updates = <String, String>{};

    // 🔴 Source node is always FAILED
    updates[impact.source.nodeId] = 'failed';

    // ⛔ Downstream shipments & inventory are BLOCKED
    for (final i in impact.downstream) {
      final type = i.node.type;

      if (type == TraceNodeType.shipment ||
          type == TraceNodeType.inventoryLot) {
        updates[i.node.nodeId] = 'blocked';
      }
    }

    return updates;
  }
}
