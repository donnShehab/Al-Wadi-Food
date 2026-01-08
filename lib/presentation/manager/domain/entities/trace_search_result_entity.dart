import 'package:equatable/equatable.dart';

class TraceSearchResultEntity extends Equatable {
  final String batchId;
  final String batchName; // ✅ جديد
  final String productName; // ✅ جديد
  final String lineName;
  final String status;
  final int risk;
  final int total;

  const TraceSearchResultEntity({
    required this.batchId,
    required this.batchName,
    required this.productName,
    required this.lineName,
    required this.status,
    required this.risk,
    required this.total,
  });

  @override
  List<Object?> get props => [
    batchId,
    batchName,
    productName,
    lineName,
    status,
    risk,
    total,
  ];
}
