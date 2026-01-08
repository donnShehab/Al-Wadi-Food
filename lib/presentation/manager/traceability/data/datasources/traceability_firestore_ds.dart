import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TraceabilityFirestoreDataSource {
  final FirebaseFirestore firestore;

  TraceabilityFirestoreDataSource(this.firestore);

  Future<QuerySnapshot<Map<String, dynamic>>> fetchLatestBatches({
    int limit = 60,
  }) {
    return firestore
        .collection(AppConstants.batchesCollection)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchTraceEvents({
    required String batchId,
  }) {
    return firestore
        .collection(AppConstants.traceEventsCollection)
        .where('batchId', isEqualTo: batchId)
        .orderBy('timestamp', descending: false)
        .get();
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
