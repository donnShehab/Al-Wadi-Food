import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/recall_audit_model.dart';
import '../../domain/repositories/traceability_repository.dart';
import 'audit_history_state.dart';

enum AuditSeverityFilter { all, low, medium, high }

/// Smart Filters + Search (Executed audits only).
///
/// ✅ Logic-safe: keeps the same Cubit name, states, and public method names.
/// Adds *UI-only* helpers (query/filter getters) and resilient Firestore parsing.
class AuditHistoryCubit extends Cubit<AuditHistoryState> {
  final TraceabilityV3Repository repository;

  AuditHistoryCubit(this.repository) : super(AuditHistoryInitial());

  List<RecallAuditModel> _allAudits = [];

  DateTimeRange? _dateRange;
  AuditSeverityFilter _severity = AuditSeverityFilter.all;
  String _query = '';

  DateTimeRange? get dateRange => _dateRange;
  AuditSeverityFilter get severity => _severity;
  String get query => _query;

  // ============================================================
  // 🔹 LOAD AUDIT HISTORY
  // ============================================================

  Future<void> loadAudits({int limit = 50}) async {
    emit(AuditHistoryLoading());

    try {
      final rawAudits = await repository.fetchRecallAudits(limit: limit);

      final parsed = <RecallAuditModel>[];
      for (final data in rawAudits) {
        // EXECUTED-only rule:
        // - If status exists, it must be EXECUTED.
        // - If status doesn't exist (older audits), allow, but only if executedAt exists.
        final status = data['status']?.toString();
        if (status != null && status.isNotEmpty && status != 'EXECUTED') {
          continue;
        }

        final executedAt = _parseDateTime(data['executedAt']);
        if (executedAt == null) {
          // Not executed or missing timestamp
          continue;
        }

        parsed.add(
          RecallAuditModel(
            managerId: (data['managerId'] ?? '').toString(),
            managerName: (data['managerName'] ?? 'Unknown').toString(),
            sourceNodeId: (data['sourceNodeId'] ?? '').toString(),
            affectedCount: _toInt(data['affectedCount']) ?? 0,
            maxDepth: _toInt(data['maxDepth']) ?? 0,
            executedAt: executedAt,
          ),
        );
      }

      _allAudits = parsed;
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
    _query = '';
    _emitFiltered();
  }

  /// UI helper (does not touch any functional logic).
  void setQuery(String value) {
    _query = value;
    _emitFiltered();
  }

  void _emitFiltered() {
    var filtered = List<RecallAuditModel>.from(_allAudits);

    // Date filter (inclusive on both ends)
    if (_dateRange != null) {
      final start = DateTime(
        _dateRange!.start.year,
        _dateRange!.start.month,
        _dateRange!.start.day,
      );
      final endExclusive = DateTime(
        _dateRange!.end.year,
        _dateRange!.end.month,
        _dateRange!.end.day,
      ).add(const Duration(days: 1));

      filtered = filtered
          .where(
            (a) =>
                a.executedAt!.isBefore(start) &&
                a.executedAt!.isBefore(endExclusive),
          )
          .toList();
    }

    // Severity filter (based on affectedCount)
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

    // Search query (manager name + source node id + numbers)
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      filtered = filtered.where((a) {
        final hay =
            '${a.managerName} ${a.sourceNodeId} ${a.affectedCount} ${a.maxDepth}'
                .toLowerCase();
        return hay.contains(q);
      }).toList();
    }

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
  // Helpers
  // ============================================================

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      return parsed;
    }
    return null;
  }

  int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }
}
