import 'dart:ui';

import 'package:alwadi_food/presentation/manager/traceability_v3/presentation/views/recall_audit_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../domain/models/recall_audit_model.dart';
import '../../domain/repositories/traceability_repository.dart';
import '../cubit/audit_history_cubit.dart';
import '../cubit/audit_history_state.dart';

class RecallAuditViewerView extends StatelessWidget {
  final TraceabilityV3Repository repository;

  const RecallAuditViewerView({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => AuditHistoryCubit(repository)..loadAudits(),
      child: DecoratedBox(
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: _GlassAppBar(
            title: 'Recall Audit History',
            actions: const [_RefreshButton(), _ExportPdfButton()],
          ),
          body: const SafeArea(child: _RecallAuditViewerBody()),
        ),
      ),
    );
  }
}

/// ============================================================
/// 📄 VIEW BODY
/// ============================================================

class _RecallAuditViewerBody extends StatelessWidget {
  const _RecallAuditViewerBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 8),
        _ExecutiveHeader(),
        SizedBox(height: 12),
        _SmartFilterBar(),
        SizedBox(height: 12),
        _KpiHeader(),
        SizedBox(height: 12),
        Expanded(child: _AuditList()),
      ],
    );
  }
}

/// ============================================================
/// 🧠 EXECUTIVE HEADER (SHORT CONTEXT)
/// ============================================================

class _ExecutiveHeader extends StatelessWidget {
  const _ExecutiveHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white.withOpacity(0.82),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
              ),
              child: Icon(
                Icons.shield_rounded,
                color: scheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Executed audits only',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Search and filter quickly for an audit-ready view.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.65),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================
/// 📊 KPI HEADER (Executive snapshot for current filters)
/// ============================================================

class _KpiHeader extends StatelessWidget {
  const _KpiHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuditHistoryCubit, AuditHistoryState>(
      builder: (context, state) {
        if (state is! AuditHistoryLoaded) return const SizedBox.shrink();

        final audits = state.audits;
        if (audits.isEmpty) return const SizedBox.shrink();

        final scheme = Theme.of(context).colorScheme;

        final total = audits.length;

        final highRisk = audits.where((a) => a.affectedCount >= 10).length;
        final attention = audits
            .where((a) => a.affectedCount >= 5 && a.affectedCount < 10)
            .length;

        final avgNodes = audits.isEmpty
            ? 0.0
            : audits.map((a) => a.affectedCount).reduce((a, b) => a + b) /
                  audits.length;

        final latest = audits
            .map((a) => a.executedAt)
            .reduce((a, b) => a.isAfter(b) ? a : b);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: scheme.primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ),
                      child: Icon(
                        Icons.dashboard_rounded,
                        color: scheme.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Executive snapshot',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    _miniPill(
                      context,
                      text: _formatDate(latest),
                      icon: Icons.schedule_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _kpiTile(
                        context,
                        label: 'Audits',
                        value: '$total',
                        icon: Icons.history_rounded,
                        tint: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _kpiTile(
                        context,
                        label: 'High risk',
                        value: '$highRisk',
                        icon: Icons.warning_amber_rounded,
                        tint: const Color(0xFFB00020),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _kpiTile(
                        context,
                        label: 'Attention',
                        value: '$attention',
                        icon: Icons.remove_red_eye_rounded,
                        tint: const Color(0xFFFF8F00),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _kpiTile(
                        context,
                        label: 'Avg nodes',
                        value: avgNodes.toStringAsFixed(1),
                        icon: Icons.device_hub_rounded,
                        tint: const Color(0xFF2E8B57),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _kpiTile(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color tint,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: tint.withOpacity(0.07),
        border: Border.all(color: tint.withOpacity(0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: tint.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: tint, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                    height: 1.0,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
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

  Widget _miniPill(
    BuildContext context, {
    required String text,
    required IconData icon,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: scheme.primary.withOpacity(0.10),
        border: Border.all(color: scheme.primary.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.primary),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 11,
              color: scheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================
/// 🔍 SMART FILTERS + SEARCH (Premium)
/// ============================================================

class _SmartFilterBar extends StatefulWidget {
  const _SmartFilterBar();

  @override
  State<_SmartFilterBar> createState() => _SmartFilterBarState();
}

class _SmartFilterBarState extends State<_SmartFilterBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuditHistoryCubit>();
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            TextField(
              controller: _controller,
              onChanged: cubit.setQuery,
              decoration: InputDecoration(
                hintText: 'Search (manager / source node / numbers)',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface.withOpacity(0.45),
                ),
                prefixIcon: Icon(Icons.search_rounded, color: scheme.primary),
                filled: true,
                fillColor: scheme.surface.withOpacity(0.75),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: scheme.primary.withOpacity(0.30),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Quick ranges
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(
                  context,
                  label: 'Today',
                  isActive: _isToday(cubit.dateRange),
                  onTap: () => cubit.applyFilters(dateRange: _todayRange()),
                ),
                _chip(
                  context,
                  label: 'Last 7 days',
                  isActive: _isLastDays(cubit.dateRange, 7),
                  onTap: () => cubit.applyFilters(dateRange: _lastDaysRange(7)),
                ),
                _chip(
                  context,
                  label: 'Last 30 days',
                  isActive: _isLastDays(cubit.dateRange, 30),
                  onTap: () =>
                      cubit.applyFilters(dateRange: _lastDaysRange(30)),
                ),
                _chip(
                  context,
                  label: 'Custom',
                  isActive:
                      cubit.dateRange != null &&
                      !_isToday(cubit.dateRange) &&
                      !_isLastDays(cubit.dateRange, 7) &&
                      !_isLastDays(cubit.dateRange, 30),
                  onTap: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2022),
                      lastDate: DateTime.now(),
                      initialDateRange: cubit.dateRange,
                    );

                    if (range != null) {
                      cubit.applyFilters(dateRange: range);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Severity
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(
                  context,
                  label: 'All',
                  isActive: cubit.severity == AuditSeverityFilter.all,
                  onTap: () =>
                      cubit.applyFilters(severity: AuditSeverityFilter.all),
                ),
                _chip(
                  context,
                  label: 'Low',
                  isActive: cubit.severity == AuditSeverityFilter.low,
                  onTap: () =>
                      cubit.applyFilters(severity: AuditSeverityFilter.low),
                ),
                _chip(
                  context,
                  label: 'Medium',
                  isActive: cubit.severity == AuditSeverityFilter.medium,
                  onTap: () =>
                      cubit.applyFilters(severity: AuditSeverityFilter.medium),
                ),
                _chip(
                  context,
                  label: 'High',
                  isActive: cubit.severity == AuditSeverityFilter.high,
                  onTap: () =>
                      cubit.applyFilters(severity: AuditSeverityFilter.high),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: () {
                    _controller.clear();
                    cubit.clearFilters();
                    setState(() {});
                  },
                  icon: Icon(Icons.close_rounded, color: scheme.primary),
                  label: Text(
                    'Clear',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: scheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () {
        onTap();
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? scheme.primary.withOpacity(0.12)
              : scheme.surface.withOpacity(0.70),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive
                ? scheme.primary.withOpacity(0.22)
                : Colors.black.withOpacity(0.06),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            color: isActive ? scheme.primary : Colors.black87,
          ),
        ),
      ),
    );
  }

  DateTimeRange _todayRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day);
    return DateTimeRange(start: start, end: end);
  }

  DateTimeRange _lastDaysRange(int days) {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = end.subtract(Duration(days: days - 1));
    return DateTimeRange(start: start, end: end);
  }

  bool _isToday(DateTimeRange? r) {
    if (r == null) return false;
    final now = DateTime.now();
    final d = DateTime(now.year, now.month, now.day);
    final s = DateTime(r.start.year, r.start.month, r.start.day);
    final e = DateTime(r.end.year, r.end.month, r.end.day);
    return s == d && e == d;
  }

  bool _isLastDays(DateTimeRange? r, int days) {
    if (r == null) return false;
    final expected = _lastDaysRange(days);
    final s = DateTime(r.start.year, r.start.month, r.start.day);
    final e = DateTime(r.end.year, r.end.month, r.end.day);
    return s == expected.start && e == expected.end;
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
          return _errorState(context, state.message);
        }

        if (state is AuditHistoryLoaded) {
          if (state.audits.isEmpty) {
            return _emptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () => context.read<AuditHistoryCubit>().loadAudits(),
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
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

  Widget _emptyState(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withOpacity(0.92),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_rounded, color: scheme.onSurfaceVariant),
              const SizedBox(width: 10),
              Text(
                'No executed audits match your filters.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorState(BuildContext context, String message) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Colors.white.withOpacity(0.92),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded, color: scheme.onSurfaceVariant),
              const SizedBox(height: 10),
              Text(
                'Unable to load audits',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withOpacity(0.65),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => context.read<AuditHistoryCubit>().loadAudits(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
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
        if (audits.isEmpty) return;

        final pdf = pw.Document();

        pdf.addPage(
          pw.Page(
            build: (context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Recall Audit Report (Executed)',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 16),
                  ...audits.map(
                    (a) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 6),
                      child: pw.Text(
                        '${a.managerName} — ${a.affectedCount} nodes — ${a.executedAt}',
                      ),
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
/// 🧾 AUDIT CARD (Premium)
/// ============================================================

class _AuditCard extends StatelessWidget {
  final RecallAuditModel audit;

  const _AuditCard({required this.audit});

  @override
  Widget build(BuildContext context) {
    final severityColor = _severityColor(audit.affectedCount);
    final repository = context.read<AuditHistoryCubit>().repository;
    final scheme = Theme.of(context).colorScheme;

    final attachments = audit.attachments;
    final attachmentCount = attachments.length;
    final hasAttachments = attachmentCount > 0;
    final note = (audit.managerNote ?? '').trim();
    final hasNote = note.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
RecallAuditDetailsView(
  audit: audit.toJson(),
  repository: repository,
)            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: severityColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: severityColor.withOpacity(0.16),
                      ),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      color: severityColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          audit.managerName,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(audit.executedAt),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: scheme.onSurface.withOpacity(0.65),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  _pill(
                    text: '${audit.affectedCount} nodes',
                    tint: severityColor,
                  ),
                  if (hasAttachments) ...[
                    const SizedBox(width: 8),
                    _iconPill(
                      icon: Icons.attach_file_rounded,
                      text: '$attachmentCount',
                      tint: scheme.primary,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _miniInfo(
                      context,
                      label: 'Source Node',
                      value: audit.sourceNodeId,
                      icon: Icons.hub_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _miniInfo(
                    context,
                    label: 'Depth',
                    value: '${audit.maxDepth}',
                    icon: Icons.account_tree_rounded,
                  ),
                ],
              ),

              if (hasNote) ...[
                const SizedBox(height: 10),
                _notePreview(context, note, scheme.primary),
              ],

              if (hasAttachments) ...[
                const SizedBox(height: 10),
                _attachmentsPreview(context, attachments),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill({required String text, required Color tint}) {
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
          color: tint,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _iconPill({
    required IconData icon,
    required String text,
    required Color tint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: tint.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tint.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: tint),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: tint,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _notePreview(BuildContext context, String note, Color tint) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: tint.withOpacity(0.06),
        border: Border.all(color: tint.withOpacity(0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.sticky_note_2_rounded, size: 18, color: tint),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              note,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.35,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentsPreview(
    BuildContext context,
    List<Map<String, dynamic>> attachments,
  ) {
    final scheme = Theme.of(context).colorScheme;

    final previews = attachments.take(3).toList();
    final remaining = attachments.length - previews.length;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: scheme.surface.withOpacity(0.75),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(Icons.photo_library_rounded, size: 18, color: scheme.primary),
          const SizedBox(width: 10),
          ...previews.map(
            (a) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _attachmentThumb(context, a),
            ),
          ),
          if (remaining > 0)
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: scheme.primary.withOpacity(0.18)),
              ),
              child: Text(
                '+$remaining',
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ),
          const Spacer(),
          Text(
            'Evidence',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.onSurface.withOpacity(0.65),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentThumb(BuildContext context, Map<String, dynamic> a) {
    final scheme = Theme.of(context).colorScheme;

    final url = (a['url'] ?? a['downloadUrl'] ?? a['link'] ?? '').toString();
    final type = (a['type'] ?? '').toString().toLowerCase();

    final isImage =
        type.contains('image') ||
        url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('.webp');

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: isImage && url.isNotEmpty
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.insert_drive_file_rounded,
                  color: scheme.onSurfaceVariant,
                  size: 20,
                ),
              )
            : Icon(
                Icons.insert_drive_file_rounded,
                color: scheme.onSurfaceVariant,
                size: 20,
              ),
      ),
    );
  }

  Widget _miniInfo(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: scheme.surface.withOpacity(0.75),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: scheme.primary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.65),
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================
/// APP BAR (Glass)
/// ============================================================

class _GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  const _GlassAppBar({required this.title, required this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: actions,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  scheme.surface.withOpacity(0.92),
                  scheme.surface.withOpacity(0.72),
                ],
              ),
              border: Border(
                bottom: BorderSide(color: Colors.black.withOpacity(0.05)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ============================================================
/// Utils
/// ============================================================

Color _severityColor(int affectedCount) {
  // executive soft semantic colors
  if (affectedCount >= 10) return const Color(0xFFB00020);
  if (affectedCount >= 5) return const Color(0xFFFF8F00);
  return const Color(0xFF2E8B57);
}

String _formatDate(DateTime dt) {
  final two = (int v) => v.toString().padLeft(2, '0');
  return '${dt.year}-${two(dt.month)}-${two(dt.day)}  ${two(dt.hour)}:${two(dt.minute)}';
}
