import 'package:equatable/equatable.dart';

class QCAlertEntity extends Equatable {
  final String batchId;
  final String batchLabel; // ✅ يظهر اسم واضح (Product + Line)
  final String reason;
  final String action;
  final String severity; // high / medium / low

  const QCAlertEntity({
    required this.batchId,
    required this.batchLabel,
    required this.reason,
    required this.action,
    required this.severity,
  });

  @override
  List<Object?> get props => [batchId, batchLabel, reason, action, severity];
}
