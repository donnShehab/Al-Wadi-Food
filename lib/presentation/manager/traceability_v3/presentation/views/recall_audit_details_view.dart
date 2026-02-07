import 'dart:ui';

import 'package:alwadi_food/presentation/manager/traceability_v3/domain/services/recall_audit_pack_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/recall_audit_model.dart';
import '../../domain/repositories/traceability_repository.dart';
import 'recall_audit_replay_view.dart';

/// Executive Audit Details (UI-only)
/// - Premium layout
/// - Export Audit Pack (PDF)
/// - Replay Traceability
class RecallAuditDetailsView extends StatelessWidget {
  final Map<String, dynamic> audit;
  final TraceabilityV3Repository repository;

  const RecallAuditDetailsView({
    super.key,
    required this.audit,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final status =
        (audit['status'] ??
                (_parseDate(audit['executedAt']) != null
                    ? 'EXECUTED'
                    : 'UNKNOWN'))
            .toString();

    final severity = (audit['severity'] ?? audit['risk'] ?? 'MEDIUM')
        .toString();
    final manager = (audit['managerName'] ?? '-').toString();
    final source = (audit['sourceNodeId'] ?? '-').toString();

    final affected = _asInt(audit['affectedCount']);
    final depth = _asInt(audit['maxDepth']);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Audit Details',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Export Audit Pack',
            onPressed: () async {
              try {
                await RecallAuditPackService.exportAndOpen(
                  context,
                  audit: audit,
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
              }
            },
            icon: Icon(Icons.picture_as_pdf_rounded, color: scheme.primary),
          ),
          const SizedBox(width: 6),
        ],
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              decoration: BoxDecoration(
                color: scheme.surface.withOpacity(0.65),
                border: Border(
                  bottom: BorderSide(color: scheme.outline.withOpacity(0.10)),
                ),
              ),
            ),
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface, // important base to avoid dark bleed
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.25,
            colors: [scheme.surface, scheme.primary.withOpacity(0.035)],
          ),
        ),
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 86, 16, 20),
            children: [
              _heroHeader(
                context,
                status: status,
                severity: severity,
                manager: manager,
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _kpiCard(
                      context,
                      label: 'Affected Nodes',
                      value: affected?.toString() ?? '-',
                      icon: Icons.account_tree_rounded,
                      tint: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _kpiCard(
                      context,
                      label: 'Max Depth',
                      value: depth?.toString() ?? '-',
                      icon: Icons.linear_scale_rounded,
                      tint: scheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              _infoCard(
                context,
                title: 'Source Node',
                subtitle: source,
                icon: Icons.location_searching_rounded,
                trailing: TextButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: source));
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Copied')));
                  },
                  icon: Icon(
                    Icons.copy_rounded,
                    color: scheme.primary,
                    size: 18,
                  ),
                  label: Text(
                    'Copy',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: scheme.primary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              _actionsRow(context),

              const SizedBox(height: 18),

              _sectionTitle(context, 'Executive Timeline'),
              const SizedBox(height: 10),
              _executiveTimeline(context),

              // Executive insight: identify the largest delay between stages (if timestamps exist).
              const SizedBox(height: 10),
              _bottleneckInsight(context),

              const SizedBox(height: 18),

              _sectionTitle(context, 'Evidence / Attachments'),
              const SizedBox(height: 10),
              _attachmentsPreview(context),

              const SizedBox(height: 18),

              _sectionTitle(context, 'Mitigation'),
              const SizedBox(height: 10),
              _mitigationPreview(context),

              const SizedBox(height: 18),

              _sectionTitle(context, 'Export'),
              const SizedBox(height: 10),
              _exportCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _executiveTimeline(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    DateTime? _firstDate(List<String> keys) {
      for (final k in keys) {
        final d = _parseDate(audit[k]);
        if (d != null) return d;
      }
      return null;
    }

    DateTime? _approvalDate() {
      final raw = audit['approvals'];
      if (raw is List && raw.isNotEmpty) {
        DateTime? last;
        for (final a in raw) {
          if (a is Map) {
            final d = _parseDate(a['approvedAt'] ?? a['at'] ?? a['time']);
            if (d != null) {
              last = d;
            }
          }
        }
        return last;
      }
      return null;
    }

    final supervisorAt = _firstDate([
      'createdAt',
      'draftAt',
      'initiatedAt',
      'startedAt',
    ]);
    final qcAt = _firstDate([
      'qcAt',
      'qcReviewedAt',
      'qcApprovedAt',
      'qcCompletedAt',
    ]);
    final submittedAt = _firstDate(['submittedAt', 'pendingAt']);
    final approvedAt = _approvalDate();
    final executedAt = _firstDate(['executedAt']);

    final now = DateTime.now();

    // Determine "current" stage for subtle emphasis (UI-only).
    int currentStage = 0;
    if (executedAt != null) {
      currentStage = 3;
    } else if (approvedAt != null) {
      currentStage = 2;
    } else if (submittedAt != null) {
      currentStage = 2;
    } else if (supervisorAt != null || qcAt != null) {
      currentStage = 1;
    }

    String _fmt(DateTime? d) {
      if (d == null) return '—';
      final local = d.toLocal();
      final hh = local.hour.toString().padLeft(2, '0');
      final mm = local.minute.toString().padLeft(2, '0');
      final dd = local.day.toString().padLeft(2, '0');
      final mo = local.month.toString().padLeft(2, '0');
      return '${local.year}-$mo-$dd  $hh:$mm';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withOpacity(0.96),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        children: [
          _timelineRow(
            context,
            index: 0,
            title: 'Supervisor',
            subtitle: 'Batch created / upstream trace start',
            time: _fmt(supervisorAt),
            icon: Icons.factory_rounded,
            isDone: supervisorAt != null,
            isActive: currentStage == 0,
            tint: scheme.primary,
          ),
          _connector(isOn: currentStage >= 1),
          _timelineRow(
            context,
            index: 1,
            title: 'QC',
            subtitle: 'Inspection & validation checkpoint',
            time: _fmt(qcAt),
            icon: Icons.fact_check_rounded,
            isDone: qcAt != null,
            isActive: currentStage == 1,
            tint: const Color(0xFF2E8B57),
          ),
          _connector(isOn: currentStage >= 2),
          _timelineRow(
            context,
            index: 2,
            title: 'Manager',
            subtitle: approvedAt != null
                ? 'Approved (${(audit['approvals'] is List) ? (audit['approvals'] as List).length : 0})'
                : (submittedAt != null ? 'Pending approval' : 'Not submitted'),
            time: _fmt(approvedAt ?? submittedAt),
            icon: Icons.verified_user_rounded,
            isDone: approvedAt != null,
            isActive: currentStage == 2,
            tint: scheme.primary,
          ),
          _connector(isOn: currentStage >= 3),
          _timelineRow(
            context,
            index: 3,
            title: 'Recall',
            subtitle: executedAt != null
                ? 'Executed & audit recorded'
                : 'Not executed yet',
            time: _fmt(executedAt),
            icon: Icons.block_rounded,
            isDone: executedAt != null,
            isActive: currentStage == 3,
            tint: const Color(0xFFB00020),
          ),
        ],
      ),
    );
  }

  /// Executive bottleneck insight
  /// UI-only: compute the largest time gap between stages when timestamps exist.
  /// No logic/state changes.
  Widget _bottleneckInsight(BuildContext context) {
    DateTime? _firstDate(List<String> keys) {
      for (final k in keys) {
        final d = _parseDate(audit[k]);
        if (d != null) return d;
      }
      return null;
    }

    DateTime? _approvalDate() {
      final raw = audit['approvals'];
      if (raw is List && raw.isNotEmpty) {
        DateTime? last;
        for (final a in raw) {
          if (a is Map) {
            final d = _parseDate(a['approvedAt'] ?? a['at'] ?? a['time']);
            if (d != null) last = d;
          }
        }
        return last;
      }
      return null;
    }

    final supervisorAt = _firstDate([
      'createdAt',
      'draftAt',
      'initiatedAt',
      'startedAt',
    ]);
    final qcAt = _firstDate([
      'qcAt',
      'qcReviewedAt',
      'qcApprovedAt',
      'qcCompletedAt',
    ]);
    final submittedAt = _firstDate(['submittedAt', 'pendingAt']);
    final approvedAt = _approvalDate();
    final executedAt = _firstDate(['executedAt']);

    // Consider manager stage time as approval time if exists, otherwise submitted time.
    final managerAt = approvedAt ?? submittedAt;

    final gaps = <_Gap>[];
    void addGap(String label, DateTime? a, DateTime? b) {
      if (a == null || b == null) return;
      final d = b.difference(a);
      if (!d.isNegative) gaps.add(_Gap(label: label, duration: d));
    }

    addGap('Supervisor → QC', supervisorAt, qcAt);
    addGap('QC → Manager', qcAt, managerAt);
    addGap('Manager → Recall', managerAt, executedAt);

    if (gaps.isEmpty) {
      return const SizedBox.shrink();
    }

    gaps.sort((x, y) => y.duration.compareTo(x.duration));
    final top = gaps.first;

    String fmt(Duration d) {
      final totalMin = d.inMinutes;
      final hours = totalMin ~/ 60;
      final minutes = totalMin % 60;
      if (hours <= 0) return '${minutes}m';
      return '${hours}h ${minutes}m';
    }

    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.primary.withOpacity(0.06),
        border: Border.all(color: scheme.primary.withOpacity(0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.timer_rounded, color: scheme.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Bottleneck: ${top.label} took ${fmt(top.duration)}.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _connector({required bool isOn}) {
    return Container(
      margin: const EdgeInsets.only(left: 22),
      height: 18,
      width: 2,
      decoration: BoxDecoration(
        color: (isOn
            ? Colors.black.withOpacity(0.18)
            : Colors.black.withOpacity(0.08)),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _timelineRow(
    BuildContext context, {
    required int index,
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required bool isDone,
    required bool isActive,
    required Color tint,
  }) {
    final scheme = Theme.of(context).colorScheme;

    final dotColor = isDone ? tint : Colors.black.withOpacity(0.22);
    final bg = isActive ? scheme.primary.withOpacity(0.06) : Colors.transparent;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: bg,
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor.withOpacity(0.16),
              border: Border.all(color: dotColor.withOpacity(0.35)),
            ),
            child: Icon(
              isDone ? Icons.check_rounded : Icons.circle_outlined,
              size: 14,
              color: dotColor,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tint.withOpacity(0.14)),
            ),
            child: Icon(icon, color: tint, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface.withOpacity(0.65),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            time,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.onSurface.withOpacity(0.70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroHeader(
    BuildContext context, {
    required String status,
    required String severity,
    required String manager,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final sev = severity.toUpperCase();
    final sevColor = _severityColor(sev);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: _executiveCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: sevColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: sevColor.withOpacity(0.16)),
            ),
            child: Icon(Icons.verified_rounded, color: sevColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recall Audit',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Manager: $manager',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _pill(status.toUpperCase(), scheme.primary),
              const SizedBox(height: 8),
              _pill(sev, sevColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionsRow(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
              backgroundColor: scheme.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final model = _toReplayModel(audit);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RecallAuditReplayView(
                    audit: model,
                    repository: repository,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text(
              'Replay Traceability',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              side: BorderSide(color: scheme.primary.withOpacity(0.35)),
              foregroundColor: scheme.primary,
            ),
            onPressed: () async {
              try {
                await RecallAuditPackService.exportAndOpen(
                  context,
                  audit: audit,
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
              }
            },
            icon: const Icon(Icons.picture_as_pdf_rounded),
            label: const Text(
              'Export Pack',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }

  Widget _exportCard(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.primary.withOpacity(0.06),
        border: Border.all(color: scheme.primary.withOpacity(0.14)),
      ),
      child: Row(
        children: [
          Icon(Icons.description_rounded, color: scheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Generate a single audit PDF (details + approvals + evidence + mitigation).',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentsPreview(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final attachments = (audit['attachments'] is List)
        ? (audit['attachments'] as List)
        : const [];

    if (attachments.isEmpty) {
      return _emptyHint(context, 'No attachments added.');
    }

    final shown = attachments.take(3).toList();
    return Column(
      children: [
        ...shown.map((e) {
          final m = (e is Map) ? e : {};
          final label = (m['label'] ?? m['name'] ?? 'Attachment').toString();
          final type = (m['type'] ?? '-').toString();
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.90),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: scheme.primary.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    type.toLowerCase().contains('image')
                        ? Icons.image_rounded
                        : Icons.attach_file_rounded,
                    color: scheme.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  type.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          );
        }),
        if (attachments.length > 3)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '+${attachments.length - 3} more',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: scheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _mitigationPreview(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final m = (audit['mitigation'] is Map)
        ? (audit['mitigation'] as Map)
        : const {};

    final reviewed = (m['reviewed'] ?? false).toString();
    final assignee = (m['followUpAssignee'] ?? '-').toString();
    final capa = (m['capaNote'] ?? '-').toString();

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.90),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          _kvRow(context, 'Reviewed', reviewed),
          const SizedBox(height: 8),
          _kvRow(context, 'Assignee', assignee),
          const SizedBox(height: 8),
          _kvRow(context, 'CAPA', capa),
        ],
      ),
    );
  }

  Widget _infoCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: _executiveCardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
            ),
            child: Icon(icon, color: scheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _kpiCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color tint,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: _executiveCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: tint.withOpacity(0.16)),
            ),
            child: Icon(icon, color: tint, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                    height: 1.0,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w900,
        color: Colors.black87,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _emptyHint(BuildContext context, String text) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.surfaceVariant.withOpacity(0.25),
        border: Border.all(color: scheme.outline.withOpacity(0.10)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: scheme.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kvRow(BuildContext context, String k, String v) {
    return Row(
      children: [
        Expanded(
          child: Text(
            k,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
        ),
        Text(
          v,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _pill(String text, Color tint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: tint.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tint.withOpacity(0.18)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 0.2,
          color: tint,
        ),
      ),
    );
  }

  BoxDecoration _executiveCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      color: Colors.white.withOpacity(0.96),
      border: Border.all(color: Colors.black.withOpacity(0.05)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 26,
          offset: const Offset(0, 16),
        ),
      ],
    );
  }

  Color _severityColor(String sev) {
    switch (sev) {
      case 'HIGH':
        return const Color(0xFFB00020);
      case 'LOW':
        return const Color(0xFF2E8B57);
      default:
        return const Color(0xFFFF8F00);
    }
  }

  int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString());
  }

  DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;

    try {
      final dyn = v;
      final toDate = dyn.toDate;
      if (toDate is Function) {
        final d = toDate();
        if (d is DateTime) return d;
      }
    } catch (_) {}

    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
    return DateTime.tryParse(v.toString());
  }

  RecallAuditModel _toReplayModel(Map<String, dynamic> a) {
    final executedAt = _parseDate(a['executedAt']) ?? DateTime.now();

    return RecallAuditModel(
      managerId: (a['managerId'] ?? '').toString(),
      managerName: (a['managerName'] ?? '').toString(),
      sourceNodeId: (a['sourceNodeId'] ?? '').toString(),
      affectedCount: _asInt(a['affectedCount']) ?? 0,
      maxDepth: _asInt(a['maxDepth']) ?? 0,
      executedAt: executedAt,
    );
  }
}

class _Gap {
  final String label;
  final Duration duration;

  const _Gap({required this.label, required this.duration});
}
