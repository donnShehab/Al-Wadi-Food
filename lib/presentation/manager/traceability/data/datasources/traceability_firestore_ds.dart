import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TraceabilityFirestoreDataSource {
  final FirebaseFirestore firestore;

  TraceabilityFirestoreDataSource(this.firestore);

  Future<QuerySnapshot<Map<String, dynamic>>> fetchLatestBatches({
    int limit = 80,
  }) async {
    return firestore
        .collection(AppConstants.batchesCollection)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchAlertReviewsForManager({
    required String managerId,
    int limit = 200,
  }) async {
    try {
      return await firestore
          .collection('trace_alert_reviews')
          .where('managerId', isEqualTo: managerId)
          // ✅ stable + latest-first (requires composite index in some projects)
          .orderBy('reviewedAt', descending: true)
          .limit(limit)
          .get();
    } on FirebaseException catch (e) {
      // ✅ Fallback: if index is missing, retry without orderBy
      // This prevents the Alerts screen from failing before index creation.
      if (e.code == 'failed-precondition') {
        return firestore
            .collection('trace_alert_reviews')
            .where('managerId', isEqualTo: managerId)
            .limit(limit)
            .get();
      }
      rethrow;
    }
  }

  Future<void> upsertAlertReviewDoc({
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await firestore
        .collection('trace_alert_reviews')
        .doc(docId)
        .set(data, SetOptions(merge: true));
  }

  Future<void> updateBatchManagerDecision(
    String batchDocId,
    Map<String, dynamic> patch,
  ) async {
    await firestore
        .collection(AppConstants.batchesCollection)
        .doc(batchDocId)
        .update(patch);
  }

  Future<void> createTraceEvent(Map<String, dynamic> data) async {
    await firestore.collection(AppConstants.traceEventsCollection).add(data);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchBatchDoc(String docId) {
    return firestore
        .collection(AppConstants.batchesCollection)
        .doc(docId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchTraceEvents(String batchId) {
    return firestore
        .collection(AppConstants.traceEventsCollection)
        .where('batchId', isEqualTo: batchId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchQcResults(String batchId) {
    return firestore
        .collection(AppConstants.qcResultsCollection)
        .where('batchId', isEqualTo: batchId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchLatestTraceEvents({
    int limit = 50,
  }) {
    return firestore
        .collection(AppConstants.traceEventsCollection)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
  }
}
