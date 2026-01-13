import 'package:flutter/material.dart';

import '../../domain/entities/trace_bundle_entity.dart';
import '../../utils/trace_status_ui_mapper.dart';
import '../../utils/trace_fallbacks.dart';
import '../../utils/trace_manager_decisions.dart';
import 'trace_risk_chip.dart';
import 'trace_attention_banner.dart';
import 'package:alwadi_food/theme.dart';

/// Top decision header for managers.
///
/// Goal: within 3 seconds a manager understands:
/// - current status
/// - meaning
/// - recommended next action
/// - last update + responsible QC officer
/// - risk badge
class TraceStatusCommandBar extends StatelessWidget {
  final TraceBundleEntity bundle;

  const TraceStatusCommandBar({super.key, required this.bundle});

  @override
  Widget build(BuildContext context) {
    final statusUi =
        TraceStatusUiMapper.fromStatus(context, bundle.batch.status);

    final lastQc = bundle.qcResults.isNotEmpty ? bundle.qcResults.first : null;
    final qcOfficer = lastQc?.qcOfficerName;
    final failureReason = lastQc?.failureReason;

    final lastUpdated = _lastUpdated(bundle);
    final lastUpdatedText = TraceFallbacks.formatTimeAgo(lastUpdated);

    final managerDecision = bundle.batch.managerDecision;
    final managerDecisionLabel = _decisionLabel(managerDecision);

    final riskScore100 = _riskScore(bundle);
    final int riskLevel = riskScore100 >= 70
        ? 3
        : riskScore100 >= 35
            ? 2
            : 0;

    final meaning = _meaningText(bundle, managerDecision);
    final nextAction = _nextActionText(bundle, managerDecision);

    final banner = _banner(bundle, managerDecision, failureReason);

    return Column(
      children: [
        if (banner != null) ...[
          banner,
          const SizedBox(height: AppSpacing.md),
        ],
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.25),
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                offset: Offset(0, 6),
                color: Color(0x12000000),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: statusUi.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(statusUi.icon, color: statusUi.color),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 6,
                          children: [
                            Text(
                              statusUi.label.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.bold
                                  .copyWith(letterSpacing: 0.6),
                            ),
                            TraceRiskChip(riskScore: riskLevel),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          meaning,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          nextAction,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.75),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.18),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _metaPill(
                    context,
                    icon: Icons.update_rounded,
                    label: 'Updated $lastUpdatedText',
                  ),
                  _metaPill(
                    context,
                    icon: Icons.verified_user_rounded,
                    label:
                        'QC: ${qcOfficer?.isNotEmpty == true ? qcOfficer : '-'}',
                  ),
                  if (managerDecisionLabel != null)
                    _metaPill(
                      context,
                      icon: Icons.gavel_rounded,
                      label: 'Manager: $managerDecisionLabel',
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  TraceAttentionBanner? _banner(
    TraceBundleEntity bundle,
    String? managerDecision,
    String? failureReason,
  ) {
    if (managerDecision == TraceManagerDecisions.hold) {
      return const TraceAttentionBanner(
        type: TraceBannerType.warning,
        title: 'Batch on HOLD',
        message:
            'Shipment is paused until the hold is cleared or batch is rejected.',
      );
    }

    if (managerDecision == TraceManagerDecisions.rejected) {
      return const TraceAttentionBanner(
        type: TraceBannerType.danger,
        title: 'Batch REJECTED',
        message:
            'This batch has been rejected by management. Ensure proper containment actions.',
      );
    }

    if (bundle.isFailed) {
      return TraceAttentionBanner(
        type: TraceBannerType.danger,
        title: 'QC FAILED — Action Required',
        message: failureReason?.isNotEmpty == true
            ? 'Failure reason: $failureReason'
            : 'This batch failed QC. Review evidence and take a decision.',
      );
    }

    if (bundle.isWaitingQc) {
      return const TraceAttentionBanner(
        type: TraceBannerType.warning,
        title: 'Waiting QC',
        message:
            'Pending inspection. Timeline updates in realtime as QC progresses.',
      );
    }

    return null;
  }

  String _meaningText(TraceBundleEntity bundle, String? managerDecision) {
    if (managerDecision == TraceManagerDecisions.approved) {
      return 'Approved by manager — ready for shipment.';
    }
    if (managerDecision == TraceManagerDecisions.rejected) {
      return 'Rejected by manager — shipment blocked.';
    }
    if (managerDecision == TraceManagerDecisions.hold) {
      return 'On hold — waiting manager follow-up.';
    }

    if (bundle.isFailed) return 'Shipment blocked until manager decision.';
    if (bundle.isWaitingQc) return 'Awaiting QC inspection.';
    if (bundle.batch.status == 'passed') return 'QC passed — ready for shipment.';
    return 'Production in progress — monitoring.';
  }

  String _nextActionText(TraceBundleEntity bundle, String? managerDecision) {
    if (managerDecision == TraceManagerDecisions.approved) {
      return 'Next: Export report and proceed to shipment release.';
    }
    if (managerDecision == TraceManagerDecisions.rejected) {
      return 'Next: Initiate containment and root-cause actions.';
    }
    if (managerDecision == TraceManagerDecisions.hold) {
      return 'Next: Request re-QC or finalize approve/reject.';
    }

    if (bundle.isFailed) {
      return 'Recommended: Review evidence → Approve / Reject / Hold.';
    }
    if (bundle.isWaitingQc) {
      return 'Recommended: Follow up with QC if SLA is approaching.';
    }
    return 'Recommended: Review timeline for completeness.';
  }

  int _riskScore(TraceBundleEntity bundle) {
    int score = 0;
    final status = bundle.batch.status;

    if (status == 'failed') score += 50;

    final batchImages = bundle.batch.images.length;
    final qcImages = bundle.qcResults.isEmpty
        ? 0
        : bundle.qcResults
            .expand((e) => e.images)
            .where((e) => e.trim().isNotEmpty)
            .length;
    if (status == 'failed' && (batchImages + qcImages) == 0) score += 20;

    final failureReason =
        bundle.qcResults.isNotEmpty ? bundle.qcResults.first.failureReason : null;
    if (status == 'failed' &&
        (failureReason == null || failureReason.trim().isEmpty)) {
      score += 15;
    }

    if (status == 'waiting_qc') {
      final ageHours = DateTime.now().difference(bundle.batch.createdAt).inHours;
      if (ageHours >= 12) score += 15;
      else if (ageHours >= 6) score += 8;
    }

    if (score > 100) score = 100;
    if (score < 0) score = 0;
    return score;
  }

  DateTime _lastUpdated(TraceBundleEntity bundle) {
    DateTime ts = bundle.batch.createdAt;
    for (final e in bundle.events) {
      if (e.timestamp.isAfter(ts)) ts = e.timestamp;
    }
    for (final q in bundle.qcResults) {
      if (q.createdAt.isAfter(ts)) ts = q.createdAt;
    }
    final mAt = bundle.batch.managerDecisionAt;
    if (mAt != null && mAt.isAfter(ts)) ts = mAt;
    return ts;
  }

  String? _decisionLabel(String? d) {
    if (d == null || d.trim().isEmpty) return null;
    switch (d) {
      case TraceManagerDecisions.approved:
        return 'Approved';
      case TraceManagerDecisions.rejected:
        return 'Rejected';
      case TraceManagerDecisions.hold:
        return 'Hold';
      default:
        return d;
    }
  }

  Widget _metaPill(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withOpacity(0.35),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outline.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.onSurface.withOpacity(0.8)),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface.withOpacity(0.85),
                ),
          ),
        ],
      ),
    );
  }
}
