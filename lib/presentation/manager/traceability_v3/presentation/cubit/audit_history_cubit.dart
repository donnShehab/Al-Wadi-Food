import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/recall_audit_model.dart';
import '../../domain/repositories/traceability_repository.dart';
import 'audit_history_state.dart';

enum AuditSeverityFilter { all, low, medium, high }

class AuditHistoryCubit extends Cubit<AuditHistoryState> {
  final TraceabilityV3Repository repository;

  AuditHistoryCubit(this.repository) : super(AuditHistoryInitial());

  List<RecallAuditModel> _allAudits = [];

  DateTimeRange? _dateRange;
  AuditSeverityFilter _severity = AuditSeverityFilter.all;

  // Expose current filters (UI needs to keep dropdown/date in sync)
  DateTimeRange? get currentDateRange => _dateRange;
  AuditSeverityFilter get currentSeverity => _severity;

  // ============================================================
  // 🔹 LOAD AUDIT HISTORY
  // ============================================================

  Future<void> loadAudits({int limit = 50}) async {
    emit(AuditHistoryLoading());

    try {
      final rawAudits = await repository.fetchRecallAudits(limit: limit);

      _allAudits = rawAudits.map((data) {
        return RecallAuditModel(
          managerId: _asString(data['managerId']),
          managerName: _asString(data['managerName']),
          sourceNodeId: _asString(data['sourceNodeId']),
          affectedCount: _asInt(data['affectedCount']),
          maxDepth: _asInt(data['maxDepth']),
          executedAt: _asDateTime(data['executedAt']),
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

    // Date filter (inclusive range)
    if (_dateRange != null) {
      filtered = filtered.where((a) {
        return !a.executedAt.isBefore(_dateRange!.start) &&
            !a.executedAt.isAfter(_dateRange!.end);
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

  // ============================================================
  // 🧰 PARSERS (makes history resilient to Firestore Timestamp)
  // ============================================================

  String _asString(dynamic v) {
    if (v == null) return '';
    return v.toString();
  }

  int _asInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  DateTime _asDateTime(dynamic v) {
    if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (v is DateTime) return v;

    // Firestore Timestamp support without importing cloud_firestore
    try {
      final dynamic d = (v as dynamic).toDate();
      if (d is DateTime) return d;
    } catch (_) {
      // ignore
    }

    if (v is int) {
      return DateTime.fromMillisecondsSinceEpoch(v);
    }

    final parsed = DateTime.tryParse(v.toString());
    if (parsed != null) return parsed;

    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
