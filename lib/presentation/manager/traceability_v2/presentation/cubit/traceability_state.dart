part of 'traceability_cubit.dart';

abstract class TraceabilityState {}

class TraceabilityInitial extends TraceabilityState {}

class TraceabilityLoading extends TraceabilityState {}

class TraceabilityError extends TraceabilityState {
  final String message;
  TraceabilityError(this.message);
}

class TraceabilityGraphLoaded extends TraceabilityState {
  final TraceGraphEntity graph;
  TraceabilityGraphLoaded(this.graph);
}

class RecallAnalysisReady extends TraceabilityState {
  final TraceGraphEntity graph;
  final RecallImpactResult impact;
  final RecallSeverity severity;

  RecallAnalysisReady({
    required this.graph,
    required this.impact,
    required this.severity,
  });
}

class RecallExecuted extends TraceabilityState {
  final Map<String, String> nodeStatusUpdates;
  RecallExecuted(this.nodeStatusUpdates);
}
