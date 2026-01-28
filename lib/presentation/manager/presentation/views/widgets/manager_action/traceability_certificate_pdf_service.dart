import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TraceabilityCertificatePdfService {
  TraceabilityCertificatePdfService();

  // ============================================================
  // ✅ FAST PREVIEW (IN-APP) — NO DISK, NO OPENFILEX
  // ============================================================
  Future<void> previewInApp({
    required BuildContext context,
    required Map<String, dynamic> batch,
    Map<String, dynamic>? audit,
    bool embedImage = true,
  }) async {
    final overlay = _PdfLoadingOverlay.show(context, message: 'Preparing PDF…');

    try {
      final bytes = await buildCertificateBytes(
        batch: batch,
        audit: audit,
        embedImage: embedImage,
      );

      overlay.close();

      await Printing.layoutPdf(
        name: _buildFileName(batch),
        format: PdfPageFormat.a4,
        onLayout: (_) async => bytes,
      );
    } catch (e) {
      overlay.close();
      _showError(context, 'Failed to generate PDF: $e');
    }
  }

  // ============================================================
  // ✅ BUILD PDF BYTES (SAFE + OPTIMIZED)
  // ============================================================
  Future<Uint8List> buildCertificateBytes({
    required Map<String, dynamic> batch,
    Map<String, dynamic>? audit,
    bool embedImage = true,
  }) async {
    final safeBatch = _sanitizeMap(batch);
    final safeAudit = audit == null ? <String, dynamic>{} : _sanitizeMap(audit);

    // --- core fields
    final batchId = _s(safeBatch['batchId'] ?? safeBatch['id']);
    final product = _s(
      safeBatch['product'] ??
          safeBatch['productName'] ??
          safeBatch['name'] ??
          safeBatch['title'],
    );
    final line = _s(safeBatch['line'] ?? safeBatch['productionLine']);
    final status = _s(safeBatch['status']).toUpperCase();
    final startTime = _s(safeBatch['startTime'] ?? safeBatch['createdAt']);

    // --- audit (optional)
    final executedBy = _s(
      safeAudit['managerName'] ?? safeAudit['executedByName'],
    );
    final executedAt = _s(safeAudit['executedAt'] ?? safeAudit['timestamp']);
    final reason = _s(safeAudit['reason'] ?? safeAudit['note']);

    // --- image (keep tiny)
    final imageUrl = _s(
      safeBatch['imageUrl'] ??
          safeBatch['productImage'] ??
          safeBatch['image'] ??
          safeBatch['photoUrl'],
    );

    pw.MemoryImage? productImg;
    if (embedImage && imageUrl.isNotEmpty) {
      final optimized = await _tryDownloadAndOptimizeImage(imageUrl);
      if (optimized != null && optimized.isNotEmpty) {
        productImg = pw.MemoryImage(optimized);
      }
    }

    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(28),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
          ),
        ),
        build: (_) => [
          _header('Traceability Certificate'),
          pw.SizedBox(height: 14),

          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (productImg != null) ...[
                pw.Container(
                  width: 64,
                  height: 64,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.ClipRRect(
                    horizontalRadius: 10,
                    verticalRadius: 10,
                    child: pw.Image(productImg, fit: pw.BoxFit.cover),
                  ),
                ),
                pw.SizedBox(width: 14),
              ],
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      product.isEmpty ? 'Product' : product,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Batch #${batchId.isEmpty ? "UNKNOWN" : batchId}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Line: ${line.isEmpty ? "-" : line}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 16),
          _sectionTitle('Batch Information'),
          _kv('Batch ID', batchId),
          _kv('Product', product),
          _kv('Line', line),
          _kv('Status', status.isEmpty ? 'UNKNOWN' : status),
          _kv('Start Time', startTime),

          pw.SizedBox(height: 14),
          _sectionTitle('Recall / Compliance'),
          _kv('Executed By', executedBy),
          _kv('Executed At', executedAt),
          if (reason.isNotEmpty && reason != '-') _kv('Reason', reason),
          _kv(
            'Generated At',
            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
          ),

          pw.SizedBox(height: 18),
          _footer(),
        ],
      ),
    );

    final bytes = await doc.save();

    // ✅ early corruption guard
    if (bytes.isEmpty || bytes.length < 800) {
      throw Exception('PDF bytes invalid (len=${bytes.length})');
    }

    return bytes;
  }

  // ============================================================
  // PDF widgets
  // ============================================================
  pw.Widget _header(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey200,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _sectionTitle(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _kv(String k, String v) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              k,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              (v.trim().isEmpty || v == 'null') ? '-' : v,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _footer() {
    return pw.Text(
      'Generated by AlWadi Food Traceability System',
      style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
    );
  }

  // ============================================================
  // Image optimization (fast + light)
  // ============================================================
  Future<Uint8List?> _tryDownloadAndOptimizeImage(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) return null;

      final resp = await http.get(uri).timeout(const Duration(seconds: 3));
      if (resp.statusCode < 200 || resp.statusCode >= 300) return null;
      if (resp.bodyBytes.isEmpty) return null;

      final decoded = img.decodeImage(resp.bodyBytes);
      if (decoded == null) return null;

      final resized = img.copyResize(
        decoded,
        width: decoded.width >= decoded.height ? 256 : null,
        height: decoded.height > decoded.width ? 256 : null,
        interpolation: img.Interpolation.average,
      );

      final jpg = img.encodeJpg(resized, quality: 70);
      return Uint8List.fromList(jpg);
    } catch (_) {
      return null; // never fail PDF if image fails
    }
  }

  // ============================================================
  // Sanitization (null + Timestamp safe)
  // ============================================================
  Map<String, dynamic> _sanitizeMap(Map<String, dynamic> input) {
    final out = <String, dynamic>{};
    input.forEach((key, value) {
      out[key] = _sanitizeValue(value);
    });
    return out;
  }

  dynamic _sanitizeValue(dynamic v) {
    if (v == null) return '-';

    if (v is Timestamp) {
      return DateFormat('yyyy-MM-dd HH:mm').format(v.toDate());
    }

    if (v is DateTime) {
      return DateFormat('yyyy-MM-dd HH:mm').format(v);
    }

    if (v is num || v is bool) return v.toString();

    if (v is String) {
      final s = v.trim();
      return s.isEmpty ? '-' : s;
    }

    if (v is List || v is Map) {
      try {
        final s = jsonEncode(v);
        return s.length > 400 ? '${s.substring(0, 400)}...' : s;
      } catch (_) {
        return v.toString();
      }
    }

    return v.toString();
  }

  String _s(dynamic v) => (v ?? '-').toString().trim();

  String _buildFileName(Map<String, dynamic> batch) {
    final safe = _sanitizeMap(batch);
    final batchId = _s(safe['batchId'] ?? safe['id']);
    final ts = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final cleanId = batchId.isEmpty
        ? 'UNKNOWN'
        : batchId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '');
    return 'traceability_${cleanId}_$ts.pdf';
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ============================================================
// ✅ Minimal “instant” loading overlay
// ============================================================
class _PdfLoadingOverlay {
  final VoidCallback close;
  const _PdfLoadingOverlay._(this.close);

  static _PdfLoadingOverlay show(
    BuildContext context, {
    String message = 'Loading…',
  }) {
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.12)),
          ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      message,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(entry);

    return _PdfLoadingOverlay._(() {
      try {
        entry.remove();
      } catch (_) {}
    });
  }
}
