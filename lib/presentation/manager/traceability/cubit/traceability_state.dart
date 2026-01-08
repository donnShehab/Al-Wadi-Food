import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_bundle_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_dashboard_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_search_result_entity.dart';
import 'package:equatable/equatable.dart';

enum TraceabilityViewStatus { idle, loading, searching, loaded, error }

class TraceabilityState extends Equatable {
  final TraceabilityViewStatus status;

  final String query;
  final String statusFilter;
  final String lineFilter;

  final List<TraceSearchResultEntity> results;
  final TraceBundleEntity? selected;
  final TraceDashboardEntity dashboard;

  final String? error;

  const TraceabilityState({
    required this.status,
    required this.query,
    required this.statusFilter,
    required this.lineFilter,
    required this.results,
    required this.selected,
    required this.dashboard,
    required this.error,
  });

  factory TraceabilityState.initial() => TraceabilityState(
    status: TraceabilityViewStatus.idle,
    query: '',
    statusFilter: 'All',
    lineFilter: 'All',
    results: const [],
    selected: null,
    dashboard: TraceDashboardEntity.empty(),
    error: null,
  );

  TraceabilityState copyWith({
    TraceabilityViewStatus? status,
    String? query,
    String? statusFilter,
    String? lineFilter,
    List<TraceSearchResultEntity>? results,
    TraceBundleEntity? selected,
    bool clearSelected = false,
    TraceDashboardEntity? dashboard,
    String? error,
  }) {
    return TraceabilityState(
      status: status ?? this.status,
      query: query ?? this.query,
      statusFilter: statusFilter ?? this.statusFilter,
      lineFilter: lineFilter ?? this.lineFilter,
      results: results ?? this.results,
      selected: clearSelected ? null : (selected ?? this.selected),
      dashboard: dashboard ?? this.dashboard,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    query,
    statusFilter,
    lineFilter,
    results,
    selected,
    dashboard,
    error,
  ];
}
