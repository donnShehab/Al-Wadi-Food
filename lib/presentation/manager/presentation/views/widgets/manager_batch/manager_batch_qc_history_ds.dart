import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';

class ManagerBatchQcHistoryFirestoreDs {
  final FirebaseFirestore firestore;
  ManagerBatchQcHistoryFirestoreDs(this.firestore);

  Future<List<Map<String, dynamic>>> fetchQcHistoryForBatch(
    String batchId,
  ) async {
    final snap = await firestore
        .collection(AppConstants.qcResultsCollection)
        .where("batchId", isEqualTo: batchId)
        .orderBy("createdAt", descending: true)
        .get();

    return snap.docs.map((d) => {"id": d.id, ...d.data()}).toList();
  }
}
