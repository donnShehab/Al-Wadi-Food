// presentation/projections/recall_ui_projection.dart

import '../../domain/models/recall_result_model.dart';
import 'recall_ui_node.dart';

class RecallUiProjection {
  /// ✅ Domain recall result (source + affectedNodes + maxDepth)
  /// Needed for severity evaluation + confirmation UX
  final RecallResultModel domainResult;

  final RecallUiNode source;
  final List<RecallUiNode> affected;

  /// Flat list of nodes for UI consumption
  final List<RecallUiNode> nodes;

  final int maxDepth;

  const RecallUiProjection({
    required this.domainResult,
    required this.source,
    required this.nodes,
    required this.affected,
    required this.maxDepth,
  });

  bool get isCritical => affected.length >= 3;
}
