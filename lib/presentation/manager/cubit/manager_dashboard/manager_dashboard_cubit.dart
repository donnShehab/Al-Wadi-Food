import 'package:alwadi_food/presentation/auth/data/services/manager_dashboard_firestore_ds.dart';
import 'package:alwadi_food/presentation/manager/domain/repo/manager_dashboard_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'manager_dashboard_state.dart';

/// Manager Dashboard Cubit
///
/// Responsibilities:
/// - Load the existing dashboard KPI data via [ManagerDashboardRepo]
/// - Compute dynamic executive metrics (health score, top priorities, notifications)
///   by querying Firestore using [ManagerDashboardFirestoreDataSource]
///
/// This keeps the UI reactive and ensures the "Health Score" reflects real data.
class ManagerDashboardCubit extends Cubit<ManagerDashboardState> {
  final ManagerDashboardRepo repo;

  /// Uses the existing Firestore DataSource used across the Manager module.
  ///
  /// Kept optional so existing DI (which only passes [repo]) continues to work.
  final ManagerDashboardFirestoreDataSource _ds;

  /// SLA thresholds used for executive calculations.
  ///
  /// - Exceeded SLA: >= 6h (affects health score)
  /// - Critical SLA: >= 12h (top priority)
  static const Duration _slaExceededThreshold = Duration(hours: 6);
  static const Duration _slaCriticalThreshold = Duration(hours: 12);

  ManagerDashboardCubit(this.repo, {ManagerDashboardFirestoreDataSource? ds})
    : _ds =
          ds ?? ManagerDashboardFirestoreDataSource(FirebaseFirestore.instance),
      super(ManagerDashboardInitial());

  Future<void> loadDashboard() async {
    emit(ManagerDashboardLoading());

    try {
      final data = await repo.getDashboardData();
      final executive = await _loadExecutiveMetricsSafe();

      emit(ManagerDashboardLoaded(data: data, executive: executive));
    } catch (e, st) {
      debugPrint("🔥 ManagerDashboard Error: $e");
      debugPrintStack(stackTrace: st);
      emit(const ManagerDashboardError("Failed to load manager dashboard"));
    }
  }

  /// Builds executive metrics with a fail-safe fallback.
  ///
  /// If anything goes wrong while computing metrics, we still show the dashboard
  /// (with empty metrics) rather than failing the entire screen.
  Future<ManagerDashboardExecutiveMetrics> _loadExecutiveMetricsSafe() async {
    try {
      return await _loadExecutiveMetrics();
    } catch (e, st) {
      debugPrint("⚠️ Executive metrics error: $e");
      debugPrintStack(stackTrace: st);
      return ManagerDashboardExecutiveMetrics.empty;
    }
  }

  Future<ManagerDashboardExecutiveMetrics> _loadExecutiveMetrics() async {
    final now = DateTime.now();

    // Fetch executive inputs in parallel (faster than sequential queries).
    final failedFuture = _ds.fetchFailedInspectionsToday();
    final highRiskFuture = _ds.fetchHighRiskAlertsToday();
    final pendingFuture = _ds.fetchPendingBatches();

    // ------------------------------------------------------------
    // Decisions waiting (Failed QC today, unresolved)
    // ------------------------------------------------------------
    final failedInspections = await failedFuture;
    final int decisionsWaitingCount = failedInspections.length;

    // ------------------------------------------------------------
    // High risk alerts today (unresolved)
    // ------------------------------------------------------------
    final highRiskAlerts = await highRiskFuture;
    final int highRiskAlertCount = highRiskAlerts.length;

    // ------------------------------------------------------------
    // SLA exceeded (Pending batches in waiting_qc)
    // ------------------------------------------------------------
    final pendingBatches = await pendingFuture;
    int slaExceededCount = 0;
    int slaCriticalCount = 0;

    // ------------------------------------------------------------
    // Top 3 Priorities (Delay > Quality > Alert)
    // ------------------------------------------------------------
    final Map<String, ManagerDashboardPriorityItem> byBatchId = {};

    // Delay priorities (SLA Critical)
    for (final b in pendingBatches) {
      final batchId = _readString(b['id']) ?? _readString(b['batchId']) ?? '';
      if (batchId.isEmpty) continue;

      final startTime = _readDate(b['updatedAt']) ?? _readDate(b['startTime']);
      if (startTime == null) continue;

      final age = now.difference(startTime);

      if (age >= _slaExceededThreshold) {
        slaExceededCount++;
      }

      // Only Critical SLA makes it to the top priorities.
      if (age >= _slaCriticalThreshold) {
        slaCriticalCount++;
        _upsertPriority(
          byBatchId,
          ManagerDashboardPriorityItem(
            batchId: batchId,
            kind: ManagerPriorityKind.delay,
            severityRank: 1,
            age: age,
            title: _batchTitleFromMap(b, batchId),
            subtitle: 'Delay • SLA ≥ ${_slaCriticalThreshold.inHours}h',
          ),
        );
      }
    }

    // Quality priorities (Decision needed)
    for (final i in failedInspections) {
      final batchId = _readString(i['batchId']) ?? '';
      if (batchId.isEmpty) continue;

      final createdAt = _readDate(i['createdAt']) ?? now;
      final age = now.difference(createdAt);

      _upsertPriority(
        byBatchId,
        ManagerDashboardPriorityItem(
          batchId: batchId,
          kind: ManagerPriorityKind.quality,
          severityRank: 2,
          age: age,
          title: 'Batch ${_shortId(batchId)}',
          subtitle: 'Quality • Decision needed',
        ),
      );
    }

    // Alert priorities (High risk)
    for (final i in highRiskAlerts) {
      final batchId = _readString(i['batchId']) ?? '';
      if (batchId.isEmpty) continue;

      final createdAt = _readDate(i['createdAt']) ?? now;
      final age = now.difference(createdAt);

      _upsertPriority(
        byBatchId,
        ManagerDashboardPriorityItem(
          batchId: batchId,
          kind: ManagerPriorityKind.alert,
          severityRank: 3,
          age: age,
          title: 'Batch ${_shortId(batchId)}',
          subtitle: 'Alert • High risk',
        ),
      );
    }

    final priorities = byBatchId.values.toList()
      ..sort((a, b) {
        final s = a.severityRank.compareTo(b.severityRank);
        if (s != 0) return s;
        return b.age.compareTo(a.age); // older first
      });

    final topPriorities = priorities.take(3).toList(growable: false);

    // ------------------------------------------------------------
    // Dynamic Health Score Logic
    // Start with 100.
    // -5 per decision waiting
    // -10 per high risk alert
    // -2 per batch exceeding SLA time
    // (Score cannot go below 0)
    // ------------------------------------------------------------
    final int healthScore = _calculateHealthScore(
      decisionsWaitingCount: decisionsWaitingCount,
      highRiskAlertCount: highRiskAlertCount,
      slaExceededCount: slaExceededCount,
    );

    return ManagerDashboardExecutiveMetrics(
      healthScore: healthScore,
      decisionsWaitingCount: decisionsWaitingCount,
      highRiskAlertCount: highRiskAlertCount,
      slaExceededCount: slaExceededCount,
      slaCriticalCount: slaCriticalCount,
      topPriorities: topPriorities,
    );
  }

  static int _calculateHealthScore({
    required int decisionsWaitingCount,
    required int highRiskAlertCount,
    required int slaExceededCount,
  }) {
    int score = 100;
    score -= 5 * decisionsWaitingCount;
    score -= 10 * highRiskAlertCount;
    score -= 2 * slaExceededCount;
    if (score < 0) score = 0;
    return score;
  }

  /// Insert or replace a priority item, keeping the most severe.
  ///
  /// - Lower [severityRank] wins.
  /// - If same rank, keep the older item.
  void _upsertPriority(
    Map<String, ManagerDashboardPriorityItem> map,
    ManagerDashboardPriorityItem item,
  ) {
    final existing = map[item.batchId];
    if (existing == null) {
      map[item.batchId] = item;
      return;
    }

    if (item.severityRank < existing.severityRank) {
      map[item.batchId] = item;
      return;
    }

    if (item.severityRank == existing.severityRank && item.age > existing.age) {
      map[item.batchId] = item;
    }
  }

  static DateTime? _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static String? _readString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static String _shortId(String id) {
    if (id.length <= 6) return id;
    return id.substring(0, 6);
  }

  static String _batchTitleFromMap(Map<String, dynamic> batch, String batchId) {
    final product = (batch['productType'] ?? batch['product'] ?? '').toString();
    final line = (batch['line'] ?? '').toString();

    final productLabel = product.isEmpty ? 'Batch' : product;
    if (line.isEmpty) return '$productLabel ${_shortId(batchId)}';
    return '$productLabel • $line';
  }
}
