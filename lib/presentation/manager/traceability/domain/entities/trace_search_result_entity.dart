// import 'package:equatable/equatable.dart';

// class TraceSearchResultEntity extends Equatable {
//   /// ✅ Firestore doc.id (used for loading batch doc)
//   final String docId;

//   /// ✅ batchId field (used for linking events/qc + displayed to manager)
//   final String batchCode;

//   final String product;
//   final String line;
//   final String status;

//   final String? imageUrl;
//   final int? quantity;
//   final DateTime? createdAt;

//   final int riskScore;

//   const TraceSearchResultEntity({
//     required this.docId,
//     required this.batchCode,
//     required this.product,
//     required this.line,
//     required this.status,
//     required this.riskScore,
//     this.imageUrl,
//     this.quantity,
//     this.createdAt,
//   });

//   @override
//   List<Object?> get props => [
//     docId,
//     batchCode,
//     product,
//     line,
//     status,
//     imageUrl,
//     quantity,
//     createdAt,
//     riskScore,
//   ];
// }
