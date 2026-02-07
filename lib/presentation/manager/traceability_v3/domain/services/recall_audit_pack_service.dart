import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// ============================================================
/// ✅ Recall Audit Pack Export (PDF)
///
/// Generates a single-audit PDF pack (Executive + Audit-ready):
/// - Header (manager, timestamps, status)
/// - KPIs (affected count, max depth)
/// - Source node
/// - Approvals (if present)
/// - Evidence / Attachments
/// - Mitigation actions
///
/// NOTE:
/// - This service is UI/utility only.
/// - It reads from a map (so it's resilient to model evolution).
/// - Requires dependencies:
///   pdf, path_provider, open_filex, intl
/// ============================================================
class RecallAuditPackService {
  static Future<File> exportAuditPackPdf(
    BuildContext context, {
    required Map<String, dynamic> audit,
  }) async {
    final now = DateTime.now();
    final fileSafeId = (audit['auditId'] ?? audit['id'] ?? 'audit').toString();

    final doc = pw.Document();

    final executedAt = _parseDate(audit['executedAt']);
    final createdAt = _parseDate(audit['createdAt']);
    final status =
        (audit['status'] ?? (executedAt != null ? 'EXECUTED' : 'UNKNOWN'))
            .toString();

    final managerName = (audit['managerName'] ?? '-').toString();
    final managerId = (audit['managerId'] ?? '-').toString();
    final sourceNodeId = (audit['sourceNodeId'] ?? '-').toString();

    final affected = _asInt(audit['affectedCount']);
    final depth = _asInt(audit['maxDepth']);

    final approvals = (audit['approvals'] is List)
        ? (audit['approvals'] as List).cast<Map>()
        : const <Map>[];
    final attachments = (audit['attachments'] is List)
        ? (audit['attachments'] as List).cast<Map>()
        : const <Map>[];

    final mitigation = (audit['mitigation'] is Map)
        ? (audit['mitigation'] as Map)
        : const <String, dynamic>{};

    final dateFmt = DateFormat('yyyy-MM-dd HH:mm');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(36, 42, 36, 42),
        build: (ctx) {
          return [
            _titleBlock(
              title: 'Recall Audit Pack',
              subtitle: 'Executive / Audit-ready record',
              rightTop: 'Status: $status',
              rightBottom: 'Generated: ${dateFmt.format(now)}',
            ),
            pw.SizedBox(height: 18),

            _sectionTitle('Audit Identity'),
            _kv('Audit ID', fileSafeId),
            _kv('Manager', managerName),
            _kv('Manager ID', managerId),
            _kv('Source Node', sourceNodeId),
            _kv('Created', createdAt != null ? dateFmt.format(createdAt) : '-'),
            _kv(
              'Executed',
              executedAt != null ? dateFmt.format(executedAt) : '-',
            ),

            pw.SizedBox(height: 14),

            _sectionTitle('KPIs'),
            pw.Row(
              children: [
                _kpiCard(
                  'Affected Nodes',
                  affected != null ? affected.toString() : '-',
                ),
                pw.SizedBox(width: 12),
                _kpiCard(
                  'Max Trace Depth',
                  depth != null ? depth.toString() : '-',
                ),
              ],
            ),

            pw.SizedBox(height: 14),

            if (approvals.isNotEmpty) ...[
              _sectionTitle('Approvals'),
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.4),
                  1: const pw.FlexColumnWidth(2.0),
                  2: const pw.FlexColumnWidth(2.0),
                },
                border: pw.TableBorder.all(
                  color: PdfColors.grey300,
                  width: 0.6,
                ),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [_th('Approver'), _th('Role'), _th('At')],
                  ),
                  ...approvals.map((a) {
                    final name = (a['name'] ?? a['approverName'] ?? '-')
                        .toString();
                    final role = (a['role'] ?? '-').toString();
                    final at = _parseDate(a['at'] ?? a['approvedAt']);
                    return pw.TableRow(
                      children: [
                        _td(name),
                        _td(role),
                        _td(at != null ? dateFmt.format(at) : '-'),
                      ],
                    );
                  }),
                ],
              ),
              pw.SizedBox(height: 14),
            ],

            _sectionTitle('Evidence / Attachments'),
            if (attachments.isEmpty)
              _note('No attachments were provided for this audit.')
            else
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(2.2),
                  1: const pw.FlexColumnWidth(1.2),
                  2: const pw.FlexColumnWidth(3.0),
                },
                border: pw.TableBorder.all(
                  color: PdfColors.grey300,
                  width: 0.6,
                ),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [_th('Label'), _th('Type'), _th('URL / Path')],
                  ),
                  ...attachments.map((e) {
                    final label = (e['label'] ?? e['name'] ?? '-').toString();
                    final type = (e['type'] ?? '-').toString();
                    final url =
                        (e['url'] ??
                                e['downloadUrl'] ??
                                e['storagePath'] ??
                                '-')
                            .toString();
                    return pw.TableRow(
                      children: [_td(label), _td(type), _td(url)],
                    );
                  }),
                ],
              ),

            pw.SizedBox(height: 14),

            _sectionTitle('Mitigation / Follow-up'),
            _kv('Reviewed', (mitigation['reviewed'] ?? false).toString()),
            _kv(
              'Follow-up Assignee',
              (mitigation['followUpAssignee'] ?? '-').toString(),
            ),
            _kv('CAPA Note', (mitigation['capaNote'] ?? '-').toString()),

            pw.SizedBox(height: 18),

            _sectionTitle('Compliance Note'),
            _note(
              'This document is generated from the system record for audit purposes. '
              'It should be retained along with approvals and supporting evidence.',
            ),
          ];
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final fileName =
        'Recall_Audit_${fileSafeId}_${DateFormat('yyyyMMdd_HHmm').format(now)}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await doc.save());
    return file;
  }

  static Future<void> exportAndOpen(
    BuildContext context, {
    required Map<String, dynamic> audit,
  }) async {
    final file = await exportAuditPackPdf(context, audit: audit);
    await OpenFilex.open(file.path);
  }

  // -------------------- PDF widgets --------------------

  static pw.Widget _titleBlock({
    required String title,
    required String subtitle,
    required String rightTop,
    required String rightBottom,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.8),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  subtitle,
                  style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
                ),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                rightTop,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                rightBottom,
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _sectionTitle(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _kv(String k, String v) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 110,
            child: pw.Text(
              k,
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          ),
          pw.Expanded(child: pw.Text(v, style: pw.TextStyle(fontSize: 10))),
        ],
      ),
    );
  }

  static pw.Widget _kpiCard(String title, String value) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,
          borderRadius: pw.BorderRadius.circular(10),
          border: pw.Border.all(color: PdfColors.grey300, width: 0.8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              value,
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _note(String text) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.8),
      ),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
      ),
    );
  }

  static pw.Widget _th(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _td(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
    );
  }

  // -------------------- parsing helpers --------------------

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString());
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;

    // Firestore Timestamp support without importing firebase types directly.
    try {
      final dyn = v;
      final toDate = dyn.toDate;
      if (toDate is Function) {
        final d = toDate();
        if (d is DateTime) return d;
      }
    } catch (_) {}

    if (v is int) {
      // assume millis
      return DateTime.fromMillisecondsSinceEpoch(v);
    }

    final s = v.toString();
    return DateTime.tryParse(s);
  }
}
