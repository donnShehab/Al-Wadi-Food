import 'package:alwadi_food/presentation/manager/traceability_v3/domain/models/recall_audit_model.dart';
import 'package:alwadi_food/presentation/manager/traceability_v3/domain/models/trace_edge_model.dart';
import 'package:alwadi_food/presentation/manager/traceability_v3/domain/models/trace_graph_model.dart';
import 'package:alwadi_food/presentation/manager/traceability_v3/domain/models/trace_node_model.dart';
import 'package:alwadi_food/presentation/manager/traceability_v3/domain/repositories/traceability_repository.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TraceabilityV3RepositoryFirestore implements TraceabilityV3Repository {
  final FirebaseFirestore firestore;

  TraceabilityV3RepositoryFirestore(this.firestore);

  // ============================================================
  // 🔹 LOAD TRACEABILITY GRAPH (with enrichment from production_batches)
  // ============================================================

  @override
  Future<TraceGraphModel> loadGraph({required String rootNodeId}) async {
    // 0) Resolve root node doc-id if trace_nodes doc.id != batchId
    String resolvedRootId = rootNodeId.trim();

    final directRoot = await firestore
        .collection('trace_nodes')
        .doc(resolvedRootId)
        .get();

    if (!directRoot.exists) {
      final byBatchId = await firestore
          .collection('trace_nodes')
          .where('batchId', isEqualTo: resolvedRootId)
          .limit(1)
          .get();

      if (byBatchId.docs.isNotEmpty) {
        resolvedRootId = byBatchId.docs.first.id;
      }
    }

    // 1) Fetch nodes (full collection; we will filter reachable)
    final nodesSnapshot = await firestore.collection('trace_nodes').get();

    // 2) Fetch edges (trace_edges preferred, else derive from trace_events)
    QuerySnapshot<Map<String, dynamic>>? edgesSnapshot;
    try {
      edgesSnapshot = await firestore.collection('trace_edges').get();
    } catch (_) {
      edgesSnapshot = null;
    }

    QuerySnapshot<Map<String, dynamic>>? eventsSnapshot;
    if (edgesSnapshot == null || edgesSnapshot.docs.isEmpty) {
      try {
        eventsSnapshot = await firestore
            .collection(AppConstants.traceEventsCollection)
            .get();
      } catch (_) {
        eventsSnapshot = null;
      }
    }

    final nodes = <String, TraceNodeModel>{};
    final edges = <TraceEdgeModel>[];

    // ---- parse trace_nodes (but don’t trust label/type/status; they may be missing)
    for (final doc in nodesSnapshot.docs) {
      final data = doc.data();

      final batchId = _stringOrNull(data['batchId']) ?? doc.id;

      nodes[doc.id] = TraceNodeModel(
        id: doc.id,
        label:
            _stringOrNull(data['label']) ??
            _stringOrNull(data['name']) ??
            'Batch #$batchId',
        type: _stringOrNull(data['type']) ?? 'unknown',
        status: _stringOrNull(data['status']) ?? 'unknown',
        quantity: _numToDoubleOrNull(data['quantity']),
        unit: _stringOrNull(data['unit']),
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ??
            DateTime.fromMillisecondsSinceEpoch(0),
        metadata: {
          // preserve batchId so we can enrich from production_batches
          'batchId': batchId,
        },
      );
    }

    void ensureNodeExists(String nodeId) {
      if (nodes.containsKey(nodeId)) return;

      // Placeholder node (will be enriched from production_batches if it exists)
      nodes[nodeId] = TraceNodeModel(
        id: nodeId,
        label: 'Batch #$nodeId',
        type: 'unknown',
        status: 'unknown',
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
        metadata: {'batchId': nodeId},
      );
    }

    // ---- edges from trace_edges
    if (edgesSnapshot != null) {
      for (final doc in edgesSnapshot.docs) {
        final data = doc.data();
        final from = (data['from'] ?? data['source'] ?? data['parentId'])
            ?.toString();
        final to = (data['to'] ?? data['target'] ?? data['childId'])
            ?.toString();

        if (from != null && from.isNotEmpty && to != null && to.isNotEmpty) {
          ensureNodeExists(from);
          ensureNodeExists(to);
          edges.add(TraceEdgeModel(from: from, to: to));
        }
      }
    }

    // ---- edges derived from trace_events (supports multiple field names)
    if (eventsSnapshot != null) {
      for (final doc in eventsSnapshot.docs) {
        final data = doc.data();

        final from =
            (data['from'] ??
                    data['source'] ??
                    data['fromNodeId'] ??
                    data['parentId'])
                ?.toString();

        final to =
            (data['to'] ??
                    data['target'] ??
                    data['toNodeId'] ??
                    data['childId'])
                ?.toString();

        if (from != null && from.isNotEmpty && to != null && to.isNotEmpty) {
          ensureNodeExists(from);
          ensureNodeExists(to);
          edges.add(TraceEdgeModel(from: from, to: to));
        }
      }
    }

    // 3) Ensure root exists even if it has NO trace_nodes and NO trace_events yet
    ensureNodeExists(resolvedRootId);

    // 4) Filter reachable nodes from root (forward traversal)
    final reachable = <String>{resolvedRootId};
    bool changed = true;

    while (changed) {
      changed = false;
      for (final e in edges) {
        if (reachable.contains(e.from) && !reachable.contains(e.to)) {
          reachable.add(e.to);
          changed = true;
        }
      }
    }

    final filteredNodes = <String, TraceNodeModel>{};
    for (final id in reachable) {
      final n = nodes[id];
      if (n != null) filteredNodes[id] = n;
    }

    final filteredEdges = edges
        .where((e) => reachable.contains(e.from) && reachable.contains(e.to))
        .toList();

    // 5) Enrich nodes from production_batches using batchId as key
    final enrichedNodes = await _enrichWithProductionBatches(filteredNodes);

    return TraceGraphModel(
      rootNodeId: resolvedRootId,
      nodes: enrichedNodes,
      edges: filteredEdges,
    );
  }

  // Future<Map<String, TraceNodeModel>> _enrichWithProductionBatches(
  //   Map<String, TraceNodeModel> input,
  // ) async {
  //   // Collect unique batchIds
  //   final batchIds = <String>{};
  //   for (final n in input.values) {
  //     final batchId = (n.metadata['batchId'] ?? n.id)?.toString().trim();
  //     if (batchId != null && batchId.isNotEmpty) batchIds.add(batchId);
  //   }

  //   // Fetch production_batches/{batchId}
  //   final batchDocs = <String, Map<String, dynamic>>{};

  //   // (No whereIn limit issues: we do doc reads)
  //   await Future.wait(
  //     batchIds.map((batchId) async {
  //       final snap = await firestore
  //           .collection(AppConstants.batchesCollection)
  //           .doc(batchId)
  //           .get();

  //       final data = snap.data();
  //       if (snap.exists && data != null) {
  //         batchDocs[batchId] = data;
  //       }
  //     }),
  //   );

  //   // Apply enrichment
  //   final out = <String, TraceNodeModel>{};

  //   for (final entry in input.entries) {
  //     final node = entry.value;
  //     final batchId =
  //         (node.metadata['batchId'] ?? node.id)?.toString().trim() ?? node.id;

  //     final batch = batchDocs[batchId];

  //     if (batch == null) {
  //       // No production batch record => keep placeholder/trace_nodes values
  //       out[entry.key] = node;
  //       continue;
  //     }

  //     final product = _stringOrNull(batch['product']);
  //     final productType = _stringOrNull(batch['productType']);
  //     final rawStatus = _stringOrNull(batch['status']) ?? node.status;

  //     final prettyStatus = _normalizeBatchStatus(rawStatus);

  //     final label = (product != null && product.isNotEmpty)
  //         ? '$product • Batch #$batchId'
  //         : node.label;

  //     final type = (productType != null && productType.isNotEmpty)
  //         ? 'Batch ($productType)'
  //         : 'Batch';

  //     final createdAt =
  //         (batch['createdAt'] as Timestamp?)?.toDate() ?? node.createdAt;

  //     out[entry.key] = node.copyWith(
  //       label: label,
  //       type: type,
  //       status: prettyStatus,
  //       createdAt: createdAt,
  //       metadata: {
  //         ...node.metadata,
  //         // bring across anything managers might need later
  //         'batchId': batchId,
  //         'product': batch['product'],
  //         'productType': batch['productType'],
  //         'quantity': batch['quantity'],
  //         'createdBy': batch['createdBy'],
  //         'operatorName': batch['operatorName'],
  //         'startTime': batch['startTime'],
  //         'endTime': batch['endTime'],
  //         'managerDecisionStatus': batch['managerDecisionStatus'],
  //         'managerDecisionById': batch['managerDecisionById'],
  //         'managerDecisionByName': batch['managerDecisionByName'],
  //       },
  //     );
  //   }

  //   return out;
  // }

  String _normalizeBatchStatus(String raw) {
    final s = raw.trim().toLowerCase();

    switch (s) {
      case 'passed':
        return 'PASSED';
      case 'failed':
        return 'FAILED';
      case 'waiting_qc':
        return 'PENDING_QC';
      case 'in_progress':
        return 'IN_PROGRESS';
      case 'blocked':
        return 'BLOCKED';
      default:
        return raw.trim().isEmpty ? 'UNKNOWN' : raw.toUpperCase();
    }
  }

  String? _stringOrNull(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  double? _numToDoubleOrNull(dynamic v) {
    if (v is num) return v.toDouble();
    return null;
  }

  // ============================================================
  // 🔹 UPDATE NODE STATUSES (ATOMIC)
  // ============================================================
  @override
  Future<void> updateNodeStatuses({
    required Map<String, String> statusUpdates,
  }) async {
    final batch = firestore.batch();

    for (final entry in statusUpdates.entries) {
      final ref = firestore.collection('trace_nodes').doc(entry.key);

      // ✅ Fix: update() fails if doc doesn't exist (your placeholders)
      // set(..., merge:true) works for both existing + missing docs
      batch.set(ref, {
        'status': entry.value,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  // ============================================================
  // 🔹 CREATE RECALL AUDIT
  // ============================================================

  @override
  Future<void> createRecallAudit({
    required Map<String, dynamic> auditPayload,
  }) async {
    await firestore.collection('recall_audits').add(auditPayload);
  }

  // ============================================================
  // 🔹 FETCH RECALL AUDITS
  // ============================================================

  @override
  Future<List<Map<String, dynamic>>> fetchRecallAudits({int limit = 50}) async {
    final snap = await firestore
        .collection('recall_audits')
        .where('status', isEqualTo: 'EXECUTED')
        .orderBy('executedAt', descending: true)
        .limit(limit)
        .get();

    return snap.docs.map((d) => d.data()).toList();
  }

  @override
  Future<void> executeRecall({
    required Map<String, String> statusUpdates,
    required RecallAuditModel audit,
  }) async {
    await updateNodeStatuses(statusUpdates: statusUpdates);

    // ✅ Optional: makes dashboard/action center reflect recall immediately
    await updateProductionBatchStatuses(statusUpdates: statusUpdates);

    await createRecallAudit(auditPayload: audit.toFirestore());
  }

  // ============================================================
  // ✅ Approval Workflow (Draft → Pending → Executed)
  // ============================================================

  @override
  Future<String> createRecallDraft({
    required Map<String, dynamic> draftPayload,
  }) async {
    final ref = await firestore.collection('recall_audits').add(draftPayload);

    // ✅ store doc id for easier updates / UI
    await ref.update({'auditId': ref.id});

    return ref.id;
  }

  @override
  Future<void> submitRecallForApproval({required String auditId}) async {
    await firestore.collection('recall_audits').doc(auditId).update({
      'status': 'PENDING',
      'submittedAt': DateTime.now(),
    });
  }

  @override
  Future<void> addRecallApproval({
    required String auditId,
    required Map<String, dynamic> approval,
  }) async {
    await firestore.collection('recall_audits').doc(auditId).update({
      'approvals': FieldValue.arrayUnion([approval]),
    });
  }

  @override
  Future<void> executeApprovedRecall({
    required String auditId,
    required Map<String, String> statusUpdates,
  }) async {
    // ✅ First: block nodes (same as normal execute)
    await updateNodeStatuses(statusUpdates: statusUpdates);

    // ✅ Keep production batches in sync (existing behavior)
    await updateProductionBatchStatuses(statusUpdates: statusUpdates);

    // ✅ Mark audit as executed (do NOT create a second audit doc)
    await firestore.collection('recall_audits').doc(auditId).update({
      'status': 'EXECUTED',
      'executedAt': DateTime.now(),
    });
  }

  Future<Map<String, TraceNodeModel>> _enrichWithProductionBatches(
    Map<String, TraceNodeModel> input,
  ) async {
    // Collect unique batchIds
    final batchIds = <String>{};
    for (final n in input.values) {
      final batchId = (n.metadata['batchId'] ?? n.id).toString().trim();
      if (batchId.isNotEmpty) batchIds.add(batchId);
    }

    // 1) Fetch production_batches/{batchId}
    final productionDocs = <String, Map<String, dynamic>>{};
    await Future.wait(
      batchIds.map((batchId) async {
        final snap = await firestore
            .collection(AppConstants.batchesCollection) // "production_batches"
            .doc(batchId)
            .get();

        final data = snap.data();
        if (snap.exists && data != null) {
          productionDocs[batchId] = data;
        }
      }),
    );

    // 2) Fetch qc_results where batchId == {batchId} (docId != batchId in your data)
    final qcDocs = <String, Map<String, dynamic>>{};
    await Future.wait(
      batchIds.map((batchId) async {
        final qc = await _fetchQcResultByBatchId(batchId);
        if (qc != null) qcDocs[batchId] = qc;
      }),
    );

    // 3) Apply enrichment
    final out = <String, TraceNodeModel>{};

    for (final entry in input.entries) {
      final node = entry.value;
      final batchId = (node.metadata['batchId'] ?? node.id).toString().trim();

      final prod = productionDocs[batchId];
      final qc = qcDocs[batchId];

      // ---- Production fields (from production_batches)
      final product = prod == null ? null : _stringOrNull(prod['product']);
      final productType = prod == null
          ? null
          : _stringOrNull(prod['productType']);
      final operatorName = prod == null
          ? null
          : _stringOrNull(prod['operatorName']);

      final prodStart = prod == null
          ? null
          : (prod['startTime'] as Timestamp?)?.toDate();
      final prodEnd = prod == null
          ? null
          : (prod['endTime'] as Timestamp?)?.toDate();

      final prodStatus = prod == null ? null : _stringOrNull(prod['status']);

      // ---- QC fields (from qc_results)
      final inspectorName = qc == null
          ? null
          : _stringOrNull(qc['inspectorName']);
      final qcResult = qc == null ? null : _stringOrNull(qc['result']);

      final qcCreated = qc == null
          ? null
          : (qc['createdAt'] as Timestamp?)?.toDate();
      final qcUpdated = qc == null
          ? null
          : (qc['updatedAt'] as Timestamp?)?.toDate();

      // ---- Determine final status shown on node card
      final finalStatus = _normalizeFinalStatus(
        qcResult: qcResult,
        productionStatus: prodStatus,
        fallback: node.status,
      );

      // ---- label/type (manager friendly)
      final label = (product != null && product.isNotEmpty)
          ? '$product • Batch #$batchId'
          : node.label;

      final type = (productType != null && productType.isNotEmpty)
          ? 'Batch ($productType)'
          : 'Batch';

      out[entry.key] = node.copyWith(
        label: label,
        type: type,
        status: finalStatus,
        metadata: {
          ...node.metadata,
          'batchId': batchId,

          // Product
          'product': product,
          'productType': productType,

          // Personnel
          'productionLead': operatorName, // Supervisor/Operator
          'qcInspectorName': inspectorName, // QC lead
          // Timestamps
          'productionStartTime': prodStart,
          'productionEndTime': prodEnd,
          'qcCreatedAt': qcCreated,
          'qcCompletedAt': qcUpdated ?? qcCreated,

          // Raw statuses
          'productionStatus': prodStatus,
          'qcResult': qcResult,
        },
      );
    }

    return out;
  }

  Future<void> updateProductionBatchStatuses({
    required Map<String, String> statusUpdates,
  }) async {
    final batch = firestore.batch();

    for (final entry in statusUpdates.entries) {
      final ref = firestore
          .collection(AppConstants.batchesCollection) // production_batches
          .doc(entry.key);

      batch.set(ref, {
        'status': entry.value.toLowerCase(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  Future<Map<String, dynamic>?> _fetchQcResultByBatchId(String batchId) async {
    final snap = await firestore
        .collection('qc_results')
        .where('batchId', isEqualTo: batchId)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return snap.docs.first.data();
  }

  String _normalizeFinalStatus({
    required String? qcResult,
    required String? productionStatus,
    required String fallback,
  }) {
    // Prefer QC result if present (because it reflects "pass/fail")
    final qc = (qcResult ?? '').trim().toLowerCase();
    if (qc.isNotEmpty) {
      if (qc == 'pass' || qc == 'passed') return 'PASSED';
      if (qc == 'fail' || qc == 'failed') return 'FAILED';
      return qc.toUpperCase();
    }

    // Else fall back to production status
    final ps = (productionStatus ?? '').trim().toLowerCase();
    if (ps.isNotEmpty) {
      if (ps == 'passed' || ps == 'pass') return 'PASSED';
      if (ps == 'failed' || ps == 'fail') return 'FAILED';
      if (ps == 'waiting_qc') return 'PENDING_QC';
      if (ps == 'in_progress') return 'IN_PROGRESS';
      return ps.toUpperCase();
    }

    return fallback.isEmpty ? 'UNKNOWN' : fallback.toUpperCase();
  }
}
