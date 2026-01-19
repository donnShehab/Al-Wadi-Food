import 'package:cloud_firestore/cloud_firestore.dart';

class TraceGraphIndexDto {
  final String nodeId;
  final List<String> incoming;
  final List<String> outgoing;
  final DateTime updatedAt;

  TraceGraphIndexDto({
    required this.nodeId,
    required this.incoming,
    required this.outgoing,
    required this.updatedAt,
  });

  factory TraceGraphIndexDto.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return TraceGraphIndexDto(
      nodeId: data['nodeId'],
      incoming: List<String>.from(data['incoming'] ?? []),
      outgoing: List<String>.from(data['outgoing'] ?? []),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'nodeId': nodeId,
    'incoming': incoming,
    'outgoing': outgoing,
    'updatedAt': Timestamp.fromDate(updatedAt),
  };
}
