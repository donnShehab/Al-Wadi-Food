import '../entities/recall_impact_result.dart';
import '../enums/trace_node_type.dart'; // ✅ REQUIRED FOR .key EXTENSION

/// ============================================================
/// 🎯 UI Projection Node
/// ============================================================

class RecallUiNode {
  final String nodeId;
  final String label;
  final String typeKey;
  final double quantity;
  final String unit;
  final bool isSource;
  final int depth;
  final List<String> path;

  const RecallUiNode({
    required this.nodeId,
    required this.label,
    required this.typeKey,
    required this.quantity,
    required this.unit,
    required this.isSource,
    required this.depth,
    required this.path,
  });
}

/// ============================================================
/// 📊 UI Projection Result
/// ============================================================

class RecallUiProjection {
  final RecallUiNode source;
  final List<RecallUiNode> affected;
  final int maxDepth;

  const RecallUiProjection({
    required this.source,
    required this.affected,
    required this.maxDepth,
  });

  bool get isCritical => affected.length >= 3;
}

/// ============================================================
/// 🧠 Projection Mapper
/// ============================================================

class TraceRecallProjection {
  TraceRecallProjection._();

  static RecallUiProjection fromDomain(RecallImpactResult result) {
    final uiNodes = <RecallUiNode>[];
    int maxDepth = 0;

    // ================= SOURCE =================
    uiNodes.add(
      RecallUiNode(
        nodeId: result.source.nodeId,
        label: result.source.label,
        typeKey: result.source.type.key, // ✅ NOW RESOLVES
        quantity: result.source.quantity,
        unit: result.source.unit,
        isSource: true,
        depth: 0,
        path: [result.source.nodeId],
      ),
    );

    // ================= IMPACTS =================
    for (final impact in result.impacts) {
      final depth = impact.path.length - 1;
      if (depth > maxDepth) maxDepth = depth;

      uiNodes.add(
        RecallUiNode(
          nodeId: impact.node.nodeId,
          label: impact.node.label,
          typeKey: impact.node.type.key, // ✅ NOW RESOLVES
          quantity: impact.affectedQuantity,
          unit: impact.node.unit,
          isSource: false,
          depth: depth,
          path: impact.path,
        ),
      );
    }

    return RecallUiProjection(
      source: uiNodes.first,
      affected: uiNodes.where((n) => !n.isSource).toList(),
      maxDepth: maxDepth,
    );
  }
}
