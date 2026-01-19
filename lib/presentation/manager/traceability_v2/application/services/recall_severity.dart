import 'package:alwadi_food/presentation/manager/traceability_v2/domain/entities/recall_impact_result.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/enums/trace_node_type.dart';


/// ============================================================
/// 🚦 Recall Severity Level
/// ============================================================

enum RecallSeverity {
  low,
  medium,
  critical,
}

extension RecallSeverityX on RecallSeverity {
  String get label {
    switch (this) {
      case RecallSeverity.low:
        return 'LOW';
      case RecallSeverity.medium:
        return 'MEDIUM';
      case RecallSeverity.critical:
        return 'CRITICAL';
    }
  }
}

/// ============================================================
/// 🧠 Severity Evaluation Engine
/// ============================================================

class RecallSeverityEngine {
  RecallSeverityEngine._();

  static RecallSeverity evaluate(
    RecallImpactResult result, {
    double criticalQuantityThreshold = 1000, // kg / pcs
  }) {
    final downstream = result.downstream;

    final affectedShipments = downstream.where(
      (i) => i.node.type == TraceNodeType.shipment,
    );

    final affectedInventory = downstream.where(
      (i) => i.node.type == TraceNodeType.inventoryLot,
    );

    final totalQuantity = downstream.fold<double>(
      0,
      (sum, i) => sum + i.affectedQuantity,
    );

    if (affectedShipments.isNotEmpty ||
        totalQuantity >= criticalQuantityThreshold) {
      return RecallSeverity.critical;
    }

    if (affectedInventory.isNotEmpty) {
      return RecallSeverity.medium;
    }

    return RecallSeverity.low;
  }
}
  