import 'package:alwadi_food/presentation/manager/domain/entities/trace_event_entity.dart';
import 'trace_events_firestore_ds.dart';

class TraceEventsRepository {
  final TraceEventsFirestoreDataSource ds;

  TraceEventsRepository(this.ds);

  Future<List<TraceEventEntity>> getBatchEvents(String batchId) async {
    return await ds.getEvents(batchId);
  }
}
