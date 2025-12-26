import 'package:equatable/equatable.dart';

class QCRecommendation extends Equatable {
  final String title;
  final String description;
  final String severity; // low, medium, high
  final String action;

  /// ✅ New
  final String? batchId;
  final String? batchLabel;

  /// ✅ type (failure, line_risk, moisture, temperature, packaging)
  final String type;

  /// ✅ NEW: list of affected batchIds
  final List<String> affectedBatches;

  const QCRecommendation({
    required this.title,
    required this.description,
    required this.severity,
    required this.action,
    this.batchId,
    this.batchLabel,
    this.type = "general",
    this.affectedBatches = const [],
  });

  @override
  List<Object?> get props => [
    title,
    description,
    severity,
    action,
    batchId,
    batchLabel,
    type,
    affectedBatches,
  ];
}
