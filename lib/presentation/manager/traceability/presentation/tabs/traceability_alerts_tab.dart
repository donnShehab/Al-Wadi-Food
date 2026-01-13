import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/theme.dart';

import '../../cubit/traceability_cubit.dart';
import '../../cubit/traceability_state.dart';
import '../../domain/entities/trace_alert_entity.dart';
import '../../utils/trace_alert_filters.dart';
import '../widgets/trace_alert_card.dart';
import '../widgets/trace_alert_filter_chips.dart';
import '../widgets/trace_alert_group_section.dart';
import '../widgets/trace_empty_state.dart';
import '../widgets/trace_loading_state.dart';
import '../widgets/trace_risk_reasons_sheet.dart';

class TraceabilityAlertsTab extends StatelessWidget {
  const TraceabilityAlertsTab({super.key});

  static const int _timelineTabIndex =
      2; // Alerts=0, Search=1, Timeline=2, Dashboard=3

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TraceabilityCubit, TraceabilityState>(
      buildWhen: (p, n) =>
          p.isLoadingAlerts != n.isLoadingAlerts ||
          p.alertsError != n.alertsError ||
          p.alerts != n.alerts ||
          p.alertsSelectedFilter != n.alertsSelectedFilter ||
          p.alertsStats != n.alertsStats,
      builder: (context, state) {
        final cubit = context.read<TraceabilityCubit>();

        final filtered = _applyFilter(state.alerts, state.alertsSelectedFilter);
        final counts = _computeChipCounts(state.alerts);

        final groups = filtered.isEmpty ? null : _groupAlerts(filtered);

        return RefreshIndicator(
          onRefresh: () => cubit.loadAlerts(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            children: [
              // ✅ Keep structure always visible (even while loading/error)
              Text(
                "Alerts Inbox",
                style: Theme.of(context).textTheme.titleLarge?.bold,
              ),
              const SizedBox(height: 6),
              Text(
                "Batches needing attention",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.72),
                ),
              ),
              const SizedBox(height: 12),

              TraceAlertFilterChips(
                selected: state.alertsSelectedFilter,
                counts: counts,
                onSelected: (k) => cubit.updateAlertsFilter(k),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${filtered.length} alerts",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => cubit.loadAlerts(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text("Refresh"),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              if (state.isLoadingAlerts)
                const TraceLoadingState(
                  title: "Loading alerts...",
                  subtitle: "Scanning latest batches for manager attention.",
                )
              else if (state.alertsError != null &&
                  state.alertsError!.trim().isNotEmpty)
                TraceEmptyState(
                  icon: Icons.error_rounded,
                  title: "Failed to load alerts",
                  subtitle: state.alertsError!,
                  action: FilledButton.icon(
                    onPressed: () => cubit.loadAlerts(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text("Retry"),
                  ),
                )
              else if (filtered.isEmpty)
                _buildEmptyStateForFilter(
                  context: context,
                  filterKey: state.alertsSelectedFilter,
                  state: state,
                )
              else
                ..._renderGroups(context, groups!),
            ],
          ),
        );
      },
    );
  }

  Map<String, int> _computeChipCounts(List<TraceAlertEntity> all) {
    int critical = 0;
    int evidence = 0;
    int sla = 0;
    int ready = 0;
    int reviewed = 0;

    for (final a in all) {
      final t = a.alertType.trim().toUpperCase();
      if (a.isReviewed) reviewed++;

      if (t == 'QC_FAILED' || t == 'SLA_CRITICAL') critical++;
      if (t == 'EVIDENCE_MISSING') evidence++;
      if (t == 'SLA_WARNING' || t == 'SLA_CRITICAL') sla++;
      if (t == 'READY') ready++;
    }

    return {
      TraceAlertFilters.all: all.length,
      TraceAlertFilters.critical: critical,
      TraceAlertFilters.evidence: evidence,
      TraceAlertFilters.sla: sla,
      TraceAlertFilters.ready: ready,
      TraceAlertFilters.reviewed: reviewed,
    };
  }

  Widget _buildEmptyStateForFilter({
    required BuildContext context,
    required String filterKey,
    required TraceabilityState state,
  }) {
    final cubit = context.read<TraceabilityCubit>();

    IconData icon = Icons.inbox_rounded;
    String title = "No alerts today";
    String subtitle =
        "Everything looks good — no batches require manager attention.";

    switch (filterKey) {
      case TraceAlertFilters.sla:
        icon = Icons.timer_off_rounded;
        title = "No SLA alerts right now";
        subtitle =
            "SLA alerts are created when a batch stays in WAITING_QC too long:\n"
            "• ≥ 6h = warning\n"
            "• ≥ 12h = critical\n\n"
            "Right now, no batches exceeded the SLA threshold.";
        break;

      case TraceAlertFilters.ready:
        icon = Icons.local_shipping_rounded;
        title = "Nothing ready to ship";
        subtitle =
            "A batch becomes READY only when:\n"
            "• QC status is PASSED\n"
            "• managerDecision is APPROVED\n\n"
            "No batches currently match both conditions.";
        break;

      case TraceAlertFilters.reviewed:
        icon = Icons.done_all_rounded;
        title = "No reviewed alerts";
        subtitle =
            "Reviewed alerts are the ones you already marked as Reviewed ✅.\n"
            "Nothing has been marked reviewed yet.";
        break;

      case TraceAlertFilters.critical:
        icon = Icons.error_rounded;
        title = "No critical alerts";
        subtitle =
            "Critical alerts appear when:\n"
            "• QC fails without a manager decision\n"
            "• WAITING_QC exceeds the SLA critical threshold (≥ 12h).\n\n"
            "No critical alerts exist right now.";
        break;

      case TraceAlertFilters.evidence:
        icon = Icons.warning_rounded;
        title = "No evidence issues";
        subtitle =
            "Evidence alerts appear when a batch is missing required photos or failure reasons.\n\n"
            "No alerts have missing/attached evidence right now.";
        break;

      case TraceAlertFilters.all:
      default:
        icon = Icons.inbox_rounded;
        title = "No alerts today";
        subtitle = "There are no alerts today.";
        break;
    }

    return TraceEmptyState(
      icon: icon,
      title: title,
      subtitle: subtitle,
      action: FilledButton.icon(
        onPressed: () => cubit.loadAlerts(),
        icon: const Icon(Icons.refresh_rounded),
        label: const Text("Refresh"),
      ),
    );
  }

  List<TraceAlertEntity> _applyFilter(
    List<TraceAlertEntity> all,
    String filter,
  ) {
    String t(TraceAlertEntity a) => a.alertType.trim().toUpperCase();

    bool isCritical(TraceAlertEntity a) {
      final type = t(a);
      return type == 'QC_FAILED' || type == 'SLA_CRITICAL';
    }

    bool isSla(TraceAlertEntity a) {
      final type = t(a);
      return type == 'SLA_WARNING' || type == 'SLA_CRITICAL';
    }

    bool isEvidence(TraceAlertEntity a) => t(a) == 'EVIDENCE_MISSING';
    bool isReady(TraceAlertEntity a) => t(a) == 'READY';

    switch (filter) {
      case TraceAlertFilters.critical:
        return all.where(isCritical).toList();
      case TraceAlertFilters.evidence:
        return all.where(isEvidence).toList();
      case TraceAlertFilters.sla:
        return all.where(isSla).toList();
      case TraceAlertFilters.ready:
        return all.where(isReady).toList();
      case TraceAlertFilters.reviewed:
        return all.where((a) => a.isReviewed).toList();
      case TraceAlertFilters.all:
      default:
        return all;
    }
  }

  Map<String, List<TraceAlertEntity>> _groupAlerts(
    List<TraceAlertEntity> list,
  ) {
    String type(TraceAlertEntity a) => a.alertType.trim().toUpperCase();

    final critical = <TraceAlertEntity>[];
    final evidence = <TraceAlertEntity>[];
    final slaWarnings = <TraceAlertEntity>[];
    final ready = <TraceAlertEntity>[];
    final reviewed = <TraceAlertEntity>[];

    for (final a in list) {
      if (a.isReviewed) {
        reviewed.add(a);
        continue;
      }

      final t = type(a);
      if (t == 'QC_FAILED' || t == 'SLA_CRITICAL') {
        critical.add(a);
      } else if (t == 'EVIDENCE_MISSING') {
        evidence.add(a);
      } else if (t == 'SLA_WARNING') {
        slaWarnings.add(a);
      } else if (t == 'READY') {
        ready.add(a);
      } else {
        evidence.add(a);
      }
    }

    return {
      'Critical Now': critical,
      'Evidence Missing': evidence,
      'SLA Warnings': slaWarnings,
      'Ready to Ship': ready,
      'Reviewed': reviewed,
    };
  }

  List<Widget> _renderGroups(
    BuildContext context,
    Map<String, List<TraceAlertEntity>> groups,
  ) {
    final cubit = context.read<TraceabilityCubit>();
    final widgets = <Widget>[];

    void addSection(String title, List<TraceAlertEntity> items) {
      if (items.isEmpty) return;

      widgets.add(
        TraceAlertGroupSection(
          title: title,
          count: items.length,
          child: Column(
            children: items.map((a) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TraceAlertCard(
                  alert: a,
                  onOpen: () async {
                    await cubit.openBatch(a.docId);
                    DefaultTabController.of(
                      context,
                    ).animateTo(_timelineTabIndex);
                  },
                  onWhy: () => _showRiskWhy(context, a),
                  onMarkReviewed: () =>
                      cubit.markAlertReviewed(batchDocId: a.docId),
                  onApprove: () => cubit.submitDecisionFromAlert(
                    alert: a,
                    decision: 'approved',
                  ),
                  onHold: (note) => cubit.submitDecisionFromAlert(
                    alert: a,
                    decision: 'hold',
                    note: note,
                  ),
                  onReject: (note) => cubit.submitDecisionFromAlert(
                    alert: a,
                    decision: 'rejected',
                    note: note,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    addSection('Critical Now', groups['Critical Now'] ?? const []);
    addSection('Evidence Missing', groups['Evidence Missing'] ?? const []);
    addSection('SLA Warnings', groups['SLA Warnings'] ?? const []);
    addSection('Ready to Ship', groups['Ready to Ship'] ?? const []);
    addSection('Reviewed', groups['Reviewed'] ?? const []);

    return widgets;
  }

  void _showRiskWhy(BuildContext context, TraceAlertEntity a) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => TraceRiskReasonsSheet(
        riskScore: a.riskScore,
        riskLabel: a.riskLabel,
        reasons: a.riskReasons,
      ),
    );
  }
}
