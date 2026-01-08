import 'package:cloud_firestore/cloud_firestore.dart';

class TraceEventEntity {
  final String id;
  final String batchId;
  final String title;
  final String description;
  final String type;
  final DateTime timestamp;
  final String? actorName;
  final String? actorRole;
  final String? status;

final String note;
  const TraceEventEntity( {
    required this.id,
    required this.batchId,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    required this.note,
    this.actorName,
    this.actorRole,
    this.status,
  });

  // ✅ Firestore Factory
  factory TraceEventEntity.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return TraceEventEntity(
      id: doc.id,
      note:  data["note"] ?? "",
      batchId: data["batchId"] ?? "",
      title: data["title"] ?? "Event",
      description: data["description"] ?? "",
      type: data["type"] ?? "general",
      timestamp: (data["timestamp"] as Timestamp).toDate(),
      actorName: data["actorName"],
      actorRole: data["actorRole"],
      status: data["status"],
    );
  }
}
