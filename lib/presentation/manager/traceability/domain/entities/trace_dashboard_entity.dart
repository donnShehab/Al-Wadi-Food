import 'package:equatable/equatable.dart';

class TraceDashboardEntity extends Equatable {
  final int totalBatches;
  final int passedCount;
  final int failedCount;
  final int waitingQcCount;
  final double passRate; // 0..100

  final List<String> latestAlerts;

  const TraceDashboardEntity({
    required this.totalBatches,
    required this.passedCount,
    required this.failedCount,
    required this.waitingQcCount,
    required this.passRate,
    required this.latestAlerts,
  });

  factory TraceDashboardEntity.empty() => const TraceDashboardEntity(
    totalBatches: 0,
    passedCount: 0,
    failedCount: 0,
    waitingQcCount: 0,
    passRate: 0,
    latestAlerts: [],
  );

  @override
  List<Object?> get props => [
    totalBatches,
    passedCount,
    failedCount,
    waitingQcCount,
    passRate,
    latestAlerts,
  ];
}
