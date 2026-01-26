import 'package:equatable/equatable.dart';

import '../../domain/models/trace_graph_model.dart';
import '../../domain/services/recall_severity_service.dart';
import '../projections/recall_ui_projection.dart';

abstract class TraceabilityState extends Equatable {
  const TraceabilityState();

  @override
  List<Object?> get props => [];
}

class TraceabilityInitial extends TraceabilityState {}

class TraceabilityLoading extends TraceabilityState {}

class TraceabilityGraphLoaded extends TraceabilityState {
  final TraceGraphModel graph;

  const TraceabilityGraphLoaded(this.graph);

  @override
  List<Object?> get props => [graph];
}

class TraceabilityRecallReady extends TraceabilityState {
  final RecallUiProjection projection;
  final RecallSeverity severity; // ✅ NEW

  const TraceabilityRecallReady({
    required this.projection,
    required this.severity,
  });

  @override
  List<Object?> get props => [projection, severity];
}

class TraceabilityRecallExecuted extends TraceabilityState {}

class TraceabilityError extends TraceabilityState {
  final String message;

  const TraceabilityError(this.message);

  @override
  List<Object?> get props => [message];
}
