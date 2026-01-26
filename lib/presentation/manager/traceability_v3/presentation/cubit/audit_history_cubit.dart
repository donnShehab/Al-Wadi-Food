import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/recall_audit_model.dart';
import '../../domain/repositories/traceability_repository.dart';
import 'audit_history_state.dart';

enum AuditSeverityFilter { all, low, medium, high }

class AuditHistoryCubit extends Cubit<AuditHistoryState> {
  final TraceabilityV3Repository  repository;

  AuditHistoryCubit(this.repository) : super(AuditHistoryInitial());

  List<RecallAuditModel> _allAudits = [];

  DateTimeRange? _dateRange;
  AuditSeverityFilter _severity = AuditSeverityFilter.all;

  // ============================================================
  // 🔹 LOAD AUDIT HISTORY
  // ============================================================

  Future<void> loadAudits({int limit = 50}) async {
    emit(AuditHistoryLoading());

    try {
      final rawAudits = await repository.fetchRecallAudits(limit: limit);

      _allAudits = rawAudits.map((data) {
        return RecallAuditModel(
          managerId: data['managerId'] as String,
          managerName: data['managerName'] as String,
          sourceNodeId: data['sourceNodeId'] as String,
          affectedCount: data['affectedCount'] as int,
          maxDepth: data['maxDepth'] as int,
          executedAt: data['executedAt'] as DateTime,
        );
      }).toList();

      _emitFiltered();
    } catch (e) {
      emit(AuditHistoryError(e.toString()));
    }
  }

  // ============================================================
  // 🔍 FILTERS
  // ============================================================

  void applyFilters({DateTimeRange? dateRange, AuditSeverityFilter? severity}) {
    _dateRange = dateRange ?? _dateRange;
    _severity = severity ?? _severity;

    _emitFiltered();
  }

  void clearFilters() {
    _dateRange = null;
    _severity = AuditSeverityFilter.all;

    _emitFiltered();
  }

  void _emitFiltered() {
    var filtered = _allAudits;

    // Date filter
    if (_dateRange != null) {
      filtered = filtered.where((a) {
        return a.executedAt.isAfter(_dateRange!.start) &&
            a.executedAt.isBefore(_dateRange!.end);
      }).toList();
    }

    // Severity filter
    filtered = filtered.where((a) {
      switch (_severity) {
        case AuditSeverityFilter.high:
          return a.affectedCount >= 10;
        case AuditSeverityFilter.medium:
          return a.affectedCount >= 5;
        case AuditSeverityFilter.low:
          return a.affectedCount < 5;
        case AuditSeverityFilter.all:
          return true;
      }
    }).toList();

    emit(AuditHistoryLoaded(filtered));
  }

  // ============================================================
  // 📄 PDF EXPORT (FILTERED)
  // ============================================================

  List<RecallAuditModel> get currentFilteredAudits {
    if (state is AuditHistoryLoaded) {
      return (state as AuditHistoryLoaded).audits;
    }
    return [];
  }
}
