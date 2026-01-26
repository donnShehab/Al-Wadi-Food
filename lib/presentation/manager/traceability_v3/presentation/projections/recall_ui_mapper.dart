// presentation/projections/recall_ui_mapper.dart

import '../../domain/models/recall_result_model.dart';
import 'recall_ui_node.dart';
import 'recall_ui_projection.dart';

class RecallUiMapper {
  RecallUiMapper._();

  static RecallUiProjection fromDomain(
    RecallResultModel result,
    Map<String, List<String>> paths,
  ) {
    final uiNodes = <RecallUiNode>[];
    int maxDepth = 0;

    for (final node in result.affectedNodes) {
      final path = paths[node.id] ?? [node.id];
      final depth = path.length - 1;

      if (depth > maxDepth) maxDepth = depth;

      uiNodes.add(
        RecallUiNode(
          nodeId: node.id,
          label: node.label,
          type: node.type,
          status: node.status,
          depth: depth,
          isSource: node.id == result.source.id,
          path: path,
          createdAt: node.createdAt,
        ),
      );
    }

    final source = uiNodes.firstWhere((n) => n.isSource);

    return RecallUiProjection(
      domainResult: result, // ✅ NEW — pass domain result to UI
      source: source,
      nodes: uiNodes,
      affected: uiNodes.where((n) => !n.isSource).toList(),
      maxDepth: maxDepth,
    );
  }
}
