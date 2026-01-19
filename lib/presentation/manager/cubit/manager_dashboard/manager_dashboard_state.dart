import 'package:alwadi_food/presentation/manager/domain/entities/manager_dashboard_entity.dart';

/// Base state for Manager Dashboard.
abstract class ManagerDashboardState {
  const ManagerDashboardState();
}

class ManagerDashboardInitial extends ManagerDashboardState {
  const ManagerDashboardInitial();
}

class ManagerDashboardLoading extends ManagerDashboardState {
  const ManagerDashboardLoading();
}

class ManagerDashboardLoaded extends ManagerDashboardState {
  /// Existing KPI/dashboard entity (kept for compatibility with the rest of the manager module).
  final ManagerDashboardEntity data;

  /// Executive control metrics (health score, priorities, notification counts, etc.).
  final ManagerDashboardExecutiveMetrics executive;

  const ManagerDashboardLoaded({
    required this.data,
    required this.executive,
  });
}

class ManagerDashboardError extends ManagerDashboardState {
  final String message;
  const ManagerDashboardError(this.message);
}

/// Types of "priority chips" shown on the dashboard.
enum ManagerPriorityKind {
  /// High risk alerts or urgent operational flags
  alert,

  /// Waiting/late batches (SLA)
  delay,

  /// QC-related issues / failed inspections requiring decision
  quality,
}

/// Single actionable priority item for the dashboard “Top Priorities” row.
class ManagerDashboardPriorityItem {
  final String batchId;

  /// Controls icon + color + meaning in the UI.
  final ManagerPriorityKind kind;

  /// Lower number = higher priority.
  /// Used in sorting (Delay -> Quality -> Alert) as requested.
  final int severityRank;

  /// How long the item has been waiting (used for display and sorting).
  final Duration age;

  /// Primary text shown on the chip.
  final String title;

  /// Secondary text shown on the chip.
  final String subtitle;

  const ManagerDashboardPriorityItem({
    required this.batchId,
    required this.kind,
    required this.severityRank,
    required this.age,
    required this.title,
    required this.subtitle,
  });

  /// Human-friendly time label used in the UI.
  /// Example: "30m", "2h", "1d"
  String get timeLabel {
    final hours = age.inHours;
    if (hours >= 24) {
      final days = (hours / 24).floor();
      return '${days}d';
    }
    if (hours >= 1) return '${hours}h';

    final minutes = age.inMinutes;
    return '${minutes <= 0 ? 1 : minutes}m';
  }
}

/// Executive-control metrics used by the dashboard home.
///
/// This is the “reactive” layer that powers the Health Score and priorities.
class ManagerDashboardExecutiveMetrics {
  /// Dynamic score (0..100) computed in the cubit.
  final int healthScore;

  /// Decisions waiting = failed QC results without decision.
  final int decisionsWaitingCount;

  /// High risk alerts today/unresolved.
  final int highRiskAlertCount;

  /// Batches exceeding SLA threshold (>= 6h).
  final int slaExceededCount;

  /// Batches exceeding critical SLA threshold (>= 12h).
  final int slaCriticalCount;

  /// Already sorted and capped to 3 in the cubit.
  final List<ManagerDashboardPriorityItem> topPriorities;

  const ManagerDashboardExecutiveMetrics({
    required this.healthScore,
    required this.decisionsWaitingCount,
    required this.highRiskAlertCount,
    required this.slaExceededCount,
    required this.slaCriticalCount,
    required this.topPriorities,
  });

  /// Notification badge count used in the AppBar.
  ///
  /// Kept intentionally “executive”: decisions + critical SLA + high risk.
  int get notificationCount =>
      decisionsWaitingCount + slaCriticalCount + highRiskAlertCount;

  /// Dynamic status message shown beside the health score.
  ///
  /// You can tweak these labels without changing logic elsewhere.
  String get statusMessage {
    if (healthScore >= 80) return 'Operational Excellence';
    if (healthScore >= 50) return 'Monitor Key Risks';
    return 'Urgent Action Required';
  }

  /// Safe empty object used when executive metrics fail to load.
  static const ManagerDashboardExecutiveMetrics empty = ManagerDashboardExecutiveMetrics(
    healthScore: 100,
    decisionsWaitingCount: 0,
    highRiskAlertCount: 0,
    slaExceededCount: 0,
    slaCriticalCount: 0,
    topPriorities: <ManagerDashboardPriorityItem>[],
  );
}
