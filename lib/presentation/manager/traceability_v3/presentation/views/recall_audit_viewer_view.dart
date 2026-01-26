import 'package:alwadi_food/presentation/manager/traceability_v3/presentation/views/recall_audit_replay_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../cubit/audit_history_cubit.dart';
import '../cubit/audit_history_state.dart';
import '../../domain/models/recall_audit_model.dart';
import '../../domain/repositories/traceability_repository.dart';

class RecallAuditViewerView extends StatelessWidget {
  final TraceabilityV3Repository  repository;

  const RecallAuditViewerView({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuditHistoryCubit(repository)..loadAudits(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recall Audit History'),
          actions: const [_ExportPdfButton()],
        ),
        body: const _RecallAuditViewerBody(),
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
        _FilterBar(),
        Expanded(child: _AuditList()),
      ],
    );
  }
}

/// ============================================================
/// 🔍 FILTER BAR
/// ============================================================

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuditHistoryCubit>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.date_range),
            label: const Text('Date'),
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2022),
                lastDate: DateTime.now(),
              );

              if (range != null) {
                cubit.applyFilters(dateRange: range);
              }
            },
          ),
          const SizedBox(width: 12),
          DropdownButton<AuditSeverityFilter>(
            value: AuditSeverityFilter.all,
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
          const Spacer(),
          TextButton(onPressed: cubit.clearFilters, child: const Text('Clear')),
        ],
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

        if (state is AuditHistoryLoaded) {
          if (state.audits.isEmpty) {
            return const Center(child: Text('No recent audits'));
          }

    return ListView.builder(
  padding: const EdgeInsets.all(12),
  itemCount: state.audits.length,
  itemBuilder: (context, index) {
    return _AuditCard(audit: state.audits[index]);
  },
);

        }

        return const SizedBox.shrink();
      },
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
      icon: const Icon(Icons.picture_as_pdf),
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


class _AuditCard extends StatelessWidget {
  final RecallAuditModel audit;

  const _AuditCard({required this.audit});

  @override
  Widget build(BuildContext context) {
    final severityColor = _severityColor(audit.affectedCount);
    final repository = context.read<AuditHistoryCubit>().repository;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  RecallAuditReplayView(audit: audit, repository: repository),
            ),
          );
        },
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: severityColor.withAlpha(40), // ~15%

            child: Icon(Icons.history, color: severityColor),
          ),
          title: Text(
            audit.managerName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(_formatDate(audit.executedAt)),
          trailing: Chip(
            label: Text(
              '${audit.affectedCount} nodes',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: severityColor,
          ),
          children: [
            _AuditDetailRow(label: 'Source Node', value: audit.sourceNodeId),
            _AuditDetailRow(
              label: 'Max Trace Depth',
              value: audit.maxDepth.toString(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
/// ============================================================
/// 📌 DETAIL ROW
/// ============================================================

class _AuditDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _AuditDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}

/// ============================================================
/// 🎨 HELPERS
/// ============================================================

Color _severityColor(int count) {
  if (count >= 10) return Colors.red;
  if (count >= 5) return Colors.orange;
  return Colors.green;
}
