import 'package:equatable/equatable.dart';

class TraceSearchResultEntity extends Equatable {
  final String batchId;

  final String product;
  final String line;
  final String status;

  final String? imageUrl;
  final int? quantity;
  final DateTime? createdAt;

  /// A simple indicator for manager UX (0..N)
  final int riskScore;

  const TraceSearchResultEntity({
    required this.batchId,
    required this.product,
    required this.line,
    required this.status,
    required this.riskScore,
    this.imageUrl,
    this.quantity,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    batchId,
    product,
    line,
    status,
    imageUrl,
    quantity,
    createdAt,
    riskScore,
  ];
}
