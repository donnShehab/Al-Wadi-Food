import 'dart:ui';

import 'package:alwadi_food/presentation/manager/traceability_v3/presentation/views/recall_audit_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../cubit/audit_history_cubit.dart';
import '../cubit/audit_history_state.dart';
import '../../domain/models/recall_audit_model.dart';
import '../../domain/repositories/traceability_repository.dart';

class RecallAuditViewerView extends StatelessWidget {
  final TraceabilityV3Repository repository;

  const RecallAuditViewerView({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuditHistoryCubit(repository)..loadAudits(),
      child: const _RecallAuditScaffold(),
    );
  }
}

class _RecallAuditScaffold extends StatelessWidget {
  const _RecallAuditScaffold();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Recall Audit History',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
        flexibleSpace: ClipRect(
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
        ),
        actions: const [
          _RefreshButton(),
          _ExportPdfButton(),
          SizedBox(width: 8),
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
          child: Column(
            children: const [
              SizedBox(height: kToolbarHeight + 10),
              _FilterBar(),
              Expanded(child: _AuditList()),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================
/// 🔄 REFRESH
/// ============================================================

class _RefreshButton extends StatelessWidget {
  const _RefreshButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Refresh',
      icon: const Icon(Icons.refresh_rounded),
      onPressed: () => context.read<AuditHistoryCubit>().loadAudits(),
    );
  }
}

/// ============================================================
/// 🔍 FILTER BAR (UI + keeps selection)
/// ============================================================

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<AuditHistoryCubit>();

    return BlocBuilder<AuditHistoryCubit, AuditHistoryState>(
      builder: (context, state) {
        final range = cubit.currentDateRange;
        final severity = cubit.currentSeverity;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Row(
            children: [
              _PillButton(
                icon: Icons.date_range_rounded,
                label: range == null ? 'Date' : _formatRange(range),
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2022),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    cubit.applyFilters(dateRange: picked);
                  }
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black.withOpacity(0.06)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<AuditSeverityFilter>(
                      isExpanded: true,
                      value: severity,
                      icon: const Icon(Icons.expand_more_rounded),
                      items: const [
                        DropdownMenuItem(
                          value: AuditSeverityFilter.all,
                          child: Text('All'),
                        ),
                        DropdownMenuItem(
                          value: AuditSeverityFilter.low,
                          child: Text('Low'),
                        ),
                        DropdownMenuItem(
                          value: AuditSeverityFilter.medium,
                          child: Text('Medium'),
                        ),
                        DropdownMenuItem(
                          value: AuditSeverityFilter.high,
                          child: Text('High'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          cubit.applyFilters(severity: value);
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  cubit.clearFilters();
                },
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onPressed,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.92),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.onSurface),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================
/// 📜 AUDIT LIST
/// ============================================================

class _AuditList extends StatelessWidget {
  const _AuditList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuditHistoryCubit, AuditHistoryState>(
      builder: (context, state) {
        if (state is AuditHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AuditHistoryError) {
          return _ErrorState(message: state.message);
        }

        if (state is AuditHistoryLoaded) {
          if (state.audits.isEmpty) {
            return const _EmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => context.read<AuditHistoryCubit>().loadAudits(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
              itemCount: state.audits.length,
              itemBuilder: (context, index) {
                return _AuditCard(audit: state.audits[index]);
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.96),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 26,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_rounded,
              size: 26,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 10),
            const Text(
              'No recent audits',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              'Audit entries appear after executing a recall from the Traceability screen.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.65),
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => context.read<AuditHistoryCubit>().loadAudits(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.96),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFB00020).withOpacity(0.22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 26,
              color: Color(0xFFB00020),
            ),
            const SizedBox(height: 10),
            const Text(
              'Unable to load audits',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.65),
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => context.read<AuditHistoryCubit>().loadAudits(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================
/// 📄 EXPORT PDF
/// ============================================================

class _ExportPdfButton extends StatelessWidget {
  const _ExportPdfButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Export PDF',
      icon: const Icon(Icons.picture_as_pdf_rounded),
      onPressed: () async {
        final audits = context.read<AuditHistoryCubit>().currentFilteredAudits;

        if (audits.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No audits to export'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }

        final pdf = pw.Document();

        pdf.addPage(
          pw.Page(
            build: (context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Recall Audit Report',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  ...audits.map(
                    (a) => pw.Text(
                      '${a.managerName} — ${a.affectedCount} nodes — ${a.executedAt}',
                    ),
                  ),
                  pw.Spacer(),
                  pw.Divider(),
                  pw.Text('Manager Signature: _____________________'),
                ],
              );
            },
          ),
        );

        await Printing.layoutPdf(onLayout: (_) => pdf.save());
      },
    );
  }
}

/// ============================================================
/// 🧾 AUDIT CARD
/// ============================================================

class _AuditCard extends StatelessWidget {
  final RecallAuditModel audit;

  const _AuditCard({required this.audit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severityColor = _severityColor(audit.affectedCount);
    final repository = context.read<AuditHistoryCubit>().repository;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.96),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  RecallAuditDetailsView(audit: audit, repository: repository),
            ),
          );
        },
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          childrenPadding: const EdgeInsets.only(bottom: 12),
          leading: CircleAvatar(
            backgroundColor: severityColor.withOpacity(0.12),
            child: Icon(Icons.history_rounded, color: severityColor),
          ),
          title: Text(
            audit.managerName.isEmpty ? 'Manager' : audit.managerName,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
          subtitle: Text(
            _formatDate(audit.executedAt),
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: severityColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: severityColor.withOpacity(0.22)),
            ),
            child: Text(
              '${audit.affectedCount} nodes',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 12,
                color: severityColor,
              ),
            ),
          ),
          children: [
            _AuditDetailRow(label: 'Source Node', value: audit.sourceNodeId),
            _AuditDetailRow(
              label: 'Max Trace Depth',
              value: audit.maxDepth.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuditDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _AuditDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}

String _formatRange(DateTimeRange range) {
  final s = range.start;
  final e = range.end;
  return '${s.day.toString().padLeft(2, '0')}/${s.month.toString().padLeft(2, '0')} '
      '- ${e.day.toString().padLeft(2, '0')}/${e.month.toString().padLeft(2, '0')}';
}

Color _severityColor(int count) {
  if (count >= 10) return const Color(0xFFB00020);
  if (count >= 5) return const Color(0xFFFF8C00);
  return const Color(0xFF2E8B57);
}
