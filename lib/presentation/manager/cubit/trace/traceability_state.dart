import 'package:alwadi_food/presentation/manager/domain/entities/trace_event_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/trace_search_result_entity.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:equatable/equatable.dart';

enum TraceabilityStatus { initial, loading, searching, loaded, error }

class TraceabilityState extends Equatable {
  final TraceabilityStatus status;

  // ✅ Search
  final String query;
  final String statusFilter;
  final String lineFilter;
  final List<TraceSearchResultEntity> searchResults;

  // ✅ Selected batch details
  final ProductionBatchEntity? selectedBatch;
  final List<QCResultEntity> qcResults;
  final List<TraceEventEntity> traceEvents;

  final String? error;

  const TraceabilityState({
    required this.status,
    required this.query,
    required this.statusFilter,
    required this.lineFilter,
    required this.searchResults,
    this.selectedBatch,
    required this.qcResults,
    required this.traceEvents,
    this.error,
  });

  factory TraceabilityState.initial() {
    return const TraceabilityState(
      status: TraceabilityStatus.initial,
      query: "",
      statusFilter: "All",
      lineFilter: "All",
      searchResults: [],
      selectedBatch: null,
      qcResults: [],
      traceEvents: [],
      error: null,
    );
  }

  TraceabilityState copyWith({
    TraceabilityStatus? status,
    String? query,
    String? statusFilter,
    String? lineFilter,
    List<TraceSearchResultEntity>? searchResults,
    ProductionBatchEntity? selectedBatch,
    List<QCResultEntity>? qcResults,
    List<TraceEventEntity>? traceEvents,
    String? error,
    bool clearSelected = false,
  }) {
    return TraceabilityState(
      status: status ?? this.status,
      query: query ?? this.query,
      statusFilter: statusFilter ?? this.statusFilter,
      lineFilter: lineFilter ?? this.lineFilter,
      searchResults: searchResults ?? this.searchResults,
      selectedBatch: clearSelected
          ? null
          : (selectedBatch ?? this.selectedBatch),
      qcResults: qcResults ?? this.qcResults,
      traceEvents: traceEvents ?? this.traceEvents,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    query,
    statusFilter,
    lineFilter,
    searchResults,
    selectedBatch,
    qcResults,
    traceEvents,
    error,
  ];
}
