import 'package:alwadi_food/presentation/manager/traceability_v2/data/models/trace_edge_dto.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/data/models/trace_graph_index_dto.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/data/models/trace_node_dto.dart';
import 'package:alwadi_food/presentation/manager/traceability_v2/domain/entities/trace_recall_audit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/trace_graph_entity.dart';
import '../../domain/repos/trace_graph_repository.dart';

class TraceGraphRepositoryFirestore implements TraceGraphRepository {
  final FirebaseFirestore firestore;

  TraceGraphRepositoryFirestore(this.firestore);

  // ============================================================
  // 🔹 CREATE NODE
  // ============================================================

  @override
  Future<void> createNode({
    required String nodeId,
    required Map<String, dynamic> payload,
  }) async {
    final ref = firestore.collection('trace_nodes').doc(nodeId);

    final exists = await ref.get();
    if (exists.exists) {
      throw Exception('TraceNode already exists: $nodeId');
    }

    await ref.set({
      ...payload,
      'nodeId': nodeId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // 🔹 CREATE EDGE + UPDATE GRAPH INDEX
  // ============================================================

  @override
  Future<void> createEdge({
    required String edgeId,
    required Map<String, dynamic> payload,
  }) async {
    final batch = firestore.batch();

    final edgeRef = firestore.collection('trace_edges').doc(edgeId);
    batch.set(edgeRef, {...payload, 'createdAt': FieldValue.serverTimestamp()});

    final fromNodeId = payload['fromNodeId'] as String;
    final toNodeId = payload['toNodeId'] as String;

    final fromIndexRef = firestore
        .collection('trace_graph_index')
        .doc(fromNodeId);
    final toIndexRef = firestore.collection('trace_graph_index').doc(toNodeId);

    batch.set(fromIndexRef, {
      'nodeId': fromNodeId,
      'outgoing': FieldValue.arrayUnion([toNodeId]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    batch.set(toIndexRef, {
      'nodeId': toNodeId,
      'incoming': FieldValue.arrayUnion([fromNodeId]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
  }

  // ============================================================
  // 🔹 LOAD GRAPH
  // ============================================================

  @override
  Future<TraceGraphEntity> loadGraph(String rootNodeId) async {
    final indexSnap = await firestore
        .collection('trace_graph_index')
        .doc(rootNodeId)
        .get();

    if (!indexSnap.exists) {
      throw Exception('Graph index not found for node $rootNodeId');
    }

    final index = TraceGraphIndexDto.fromDoc(indexSnap);

    final nodeIds = {rootNodeId, ...index.incoming, ...index.outgoing}.toList();

    // Load nodes
    final nodesSnap = await firestore
        .collection('trace_nodes')
        .where('nodeId', whereIn: nodeIds)
        .get();

    final nodes = {
      for (final d in nodesSnap.docs) d.id: TraceNodeDto.fromDoc(d).toEntity(),
    };

    // Load edges
    final edgesSnap = await firestore
        .collection('trace_edges')
        .where('fromNodeId', whereIn: nodeIds)
        .get();

    final edges = edgesSnap.docs
        .map((d) => TraceEdgeDto.fromDoc(d).toEntity())
        .toList();

    return TraceGraphEntity(nodes: nodes, edges: edges);
  }

  
  // ============================================================
  // 🔒 EXECUTE RECALL + AUDIT (ATOMIC)
  // ============================================================

  @override
  Future<void> executeRecallTransaction({
    required Map<String, String> statusUpdates,
    required TraceRecallAudit audit,
  }) async {
    final batch = firestore.batch();

    // 1️⃣ Update node statuses
    for (final entry in statusUpdates.entries) {
      final nodeRef = firestore.collection('trace_nodes').doc(entry.key);

      batch.update(nodeRef, {
        'status': entry.value,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // 2️⃣ Create audit log
    final auditRef = firestore.collection('trace_audits').doc();
    batch.set(auditRef, audit.toFirestore());

    // 3️⃣ Commit atomically
    await batch.commit();
  }
}
