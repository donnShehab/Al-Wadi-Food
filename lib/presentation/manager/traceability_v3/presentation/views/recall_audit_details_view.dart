import 'dart:ui';

import 'package:alwadi_food/presentation/manager/traceability_v3/presentation/views/recall_audit_replay_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/models/recall_audit_model.dart';
import '../../domain/repositories/traceability_repository.dart';

/// Executive Audit Details (A): fast, clear, audit-ready.
/// UI-only screen. No logic/state changes.
class RecallAuditDetailsView extends StatelessWidget {
  final RecallAuditModel audit;
  final TraceabilityV3Repository repository;

  const RecallAuditDetailsView({
    super.key,
    required this.audit,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severityColor = _severityColor(audit.affectedCount);
    final severityLabel = _severityLabel(audit.affectedCount);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Audit Details',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
        flexibleSpace: _glassAppBar(theme),
        actions: [
          IconButton(
            tooltip: 'Copy Batch ID',
            icon: const Icon(Icons.copy_rounded),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: audit.sourceNodeId));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Source node copied')),
                );
              }
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.25,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primary.withOpacity(0.035),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 14, 16, 18),
            children: [
              _headerCard(
                context,
                severityColor: severityColor,
                severityLabel: severityLabel,
              ),
              const SizedBox(height: 14),
              _kpiRow(context, severityColor),
              const SizedBox(height: 14),
              _sourceCard(context),
              const SizedBox(height: 14),
              _complianceCard(context),
              const SizedBox(height: 18),
              _primaryActions(context),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassAppBar(ThemeData theme) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.surface.withOpacity(0.92),
                theme.colorScheme.surface.withOpacity(0.65),
              ],
            ),
            border: Border(
              bottom: BorderSide(color: Colors.black.withOpacity(0.06)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerCard(
    BuildContext context, {
    required Color severityColor,
    required String severityLabel,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: _executiveCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: severityColor.withOpacity(0.18)),
                ),
                child: Icon(
                  Icons.verified_user_rounded,
                  color: severityColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      audit.managerName.isEmpty ? 'Manager' : audit.managerName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(audit.executedAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),
              _pill(severityLabel, severityColor),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'This audit record is immutable and designed for executive review and compliance.',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.65),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpiRow(BuildContext context, Color severityColor) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _kpiCard(
            context,
            title: 'Affected Nodes',
            value: '${audit.affectedCount}',
            tint: severityColor,
            icon: Icons.hub_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _kpiCard(
            context,
            title: 'Max Trace Depth',
            value: '${audit.maxDepth}',
            tint: theme.colorScheme.primary,
            icon: Icons.account_tree_rounded,
          ),
        ),
      ],
    );
  }

  Widget _kpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required Color tint,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: tint.withOpacity(0.07),
        border: Border.all(color: tint.withOpacity(0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: tint),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
              color: Colors.black87,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sourceCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: _executiveCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Source Node',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: theme.colorScheme.surface.withOpacity(0.90),
                    border: Border.all(color: Colors.black.withOpacity(0.06)),
                  ),
                  child: Text(
                    audit.sourceNodeId,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.2,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: audit.sourceNodeId),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Source node copied')),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text('Copy'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary,
                    side: BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.25),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _complianceCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: theme.colorScheme.primary.withOpacity(0.06),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_rounded,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Compliance note: this record includes timestamps and responsible manager. It should be used for internal audits and reporting.',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryActions(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecallAuditReplayView(
                    audit: audit,
                    repository: repository,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.play_circle_rounded),
            label: const Text('Replay Traceability'),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w900),
            ),
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
}

BoxDecoration _executiveCardDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(22),
    color: Colors.white.withOpacity(0.96),
    border: Border.all(color: Colors.black.withOpacity(0.06)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 26,
        offset: const Offset(0, 16),
      ),
    ],
  );
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}

String _severityLabel(int count) {
  if (count >= 10) return 'HIGH RISK';
  if (count >= 5) return 'MEDIUM';
  return 'LOW RISK';
}

Color _severityColor(int count) {
  if (count >= 10) return const Color(0xFFB00020);
  if (count >= 5) return const Color(0xFFFF8C00);
  return const Color(0xFF2E8B57);
}
