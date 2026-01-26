// import 'package:equatable/equatable.dart';

// class TraceBatchEntity extends Equatable {
//   final String docId; // Firestore doc.id
//   final String batchId; // internal batch code (field batchId)

//   final String product;
//   final String line;
//   final int quantity;
//   final DateTime createdAt;
//   final String status;

//   final String createdBy; // userId
//   final List<String> images;

//   // Manager decision workflow (optional until manager acts)
//   final String? managerDecision; // approved / rejected / hold
//   final DateTime? managerDecisionAt;
//   final String? managerDecisionById;
//   final String? managerDecisionByName;
//   final String? managerDecisionNote;

//   const TraceBatchEntity({
//     required this.docId,
//     required this.batchId,
//     required this.product,
//     required this.line,
//     required this.quantity,
//     required this.createdAt,
//     required this.status,
//     required this.createdBy,
//     required this.images,
//     this.managerDecision,
//     this.managerDecisionAt,
//     this.managerDecisionById,
//     this.managerDecisionByName,
//     this.managerDecisionNote,
//   });

//   /// ✅ General-purpose copyWith (supports decision + any field updates)
//   TraceBatchEntity copyWith({
//     String? docId,
//     String? batchId,
//     String? product,
//     String? line,
//     int? quantity,
//     DateTime? createdAt,
//     String? status,
//     String? createdBy,
//     List<String>? images,
//     String? managerDecision,
//     DateTime? managerDecisionAt,
//     String? managerDecisionById,
//     String? managerDecisionByName,
//     String? managerDecisionNote,
//     bool clearManagerDecisionNote = false,
//   }) {
//     return TraceBatchEntity(
//       docId: docId ?? this.docId,
//       batchId: batchId ?? this.batchId,
//       product: product ?? this.product,
//       line: line ?? this.line,
//       quantity: quantity ?? this.quantity,
//       createdAt: createdAt ?? this.createdAt,
//       status: status ?? this.status,
//       createdBy: createdBy ?? this.createdBy,
//       images: images ?? this.images,
//       managerDecision: managerDecision ?? this.managerDecision,
//       managerDecisionAt: managerDecisionAt ?? this.managerDecisionAt,
//       managerDecisionById: managerDecisionById ?? this.managerDecisionById,
//       managerDecisionByName:
//           managerDecisionByName ?? this.managerDecisionByName,
//       managerDecisionNote: clearManagerDecisionNote
//           ? null
//           : (managerDecisionNote ?? this.managerDecisionNote),
//     );
//   }

//   @override
//   List<Object?> get props => [
//     docId,
//     batchId,
//     product,
//     line,
//     quantity,
//     createdAt,
//     status,
//     createdBy,
//     images,
//     managerDecision,
//     managerDecisionAt,
//     managerDecisionById,
//     managerDecisionByName,
//     managerDecisionNote,
//   ];
// }
