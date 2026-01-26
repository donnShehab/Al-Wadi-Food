// import 'package:equatable/equatable.dart';

// class TraceAlertEntity extends Equatable {
//   final String docId;
//   final String batchId;
//   final String product;
//   final String line;
//   final String status;
//   final int quantity;
//   final DateTime createdAt;

//   /// 0..100
//   final int riskScore;

//   /// HIGH / MEDIUM / LOW
//   final String riskLabel;

//   /// Risk breakdown reasons
//   final List<String> riskReasons;

//   /// QC_FAILED / EVIDENCE_MISSING / SLA_WARNING / SLA_CRITICAL / READY
//   final String alertType;

//   final String message;
//   final DateTime updatedAt;

//   final String? managerDecision;

//   /// Reviewed workflow
//   final bool isReviewed;
//   final DateTime? reviewedAt;

//   /// For sorting (smaller = more important)
//   final int severityRank;

//   const TraceAlertEntity({
//     required this.docId,
//     required this.batchId,
//     required this.product,
//     required this.line,
//     required this.status,
//     required this.quantity,
//     required this.createdAt,
//     required this.riskScore,
//     required this.riskLabel,
//     required this.riskReasons,
//     required this.alertType,
//     required this.message,
//     required this.updatedAt,
//     required this.managerDecision,
//     required this.isReviewed,
//     required this.reviewedAt,
//     required this.severityRank,
//   });

//   TraceAlertEntity copyWith({bool? isReviewed, DateTime? reviewedAt}) {
//     return TraceAlertEntity(
//       docId: docId,
//       batchId: batchId,
//       product: product,
//       line: line,
//       status: status,
//       quantity: quantity,
//       createdAt: createdAt,
//       riskScore: riskScore,
//       riskLabel: riskLabel,
//       riskReasons: riskReasons,
//       alertType: alertType,
//       message: message,
//       updatedAt: updatedAt,
//       managerDecision: managerDecision,
//       isReviewed: isReviewed ?? this.isReviewed,
//       reviewedAt: reviewedAt ?? this.reviewedAt,
//       severityRank: severityRank,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     docId,
//     batchId,
//     product,
//     line,
//     status,
//     quantity,
//     createdAt,
//     riskScore,
//     riskLabel,
//     riskReasons,
//     alertType,
//     message,
//     updatedAt,
//     managerDecision,
//     isReviewed,
//     reviewedAt,
//     severityRank,
//   ];
// }
