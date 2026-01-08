import 'package:alwadi_food/presentation/manager/domain/entities/trace_event_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TraceEventsFirestoreDataSource {
  final FirebaseFirestore firestore;

  TraceEventsFirestoreDataSource(this.firestore);

  Future<List<TraceEventEntity>> getEvents(String batchId) async {
    final snap = await firestore
        .collection("trace_events")
        .where("batchId", isEqualTo: batchId)
        .orderBy("timestamp", descending: false)
        .get();

    return snap.docs.map((e) => TraceEventEntity.fromFirestore(e)).toList();
  }
}
