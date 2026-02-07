import 'dart:io';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_summary_entity.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/reports/reports_center_firestore_ds.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_plus/share_plus.dart';

class ReportsExcelService {
  Future<File> generateSummaryExcel({
    required ReportsRange range,
    required ReportsSummaryEntity summary,
    required List<Map<String, dynamic>> inspections,
  }) async {
    final excel = Excel.createExcel();

    // ✅ Sheet 1: Summary
    final summarySheet = excel['Summary'];
    summarySheet.appendRow([TextCellValue("Alwadi Food Factory - QC Reports")]);
    summarySheet.appendRow([
      TextCellValue("Range"),
      TextCellValue(_rangeLabel(range)),
    ]);
    summarySheet.appendRow([
      TextCellValue("Generated At"),
      TextCellValue(DateTime.now().toString()),
    ]);
    summarySheet.appendRow([]);

    summarySheet.appendRow([
      TextCellValue("Total Inspections"),
      IntCellValue(summary.totalInspections),
    ]);
    summarySheet.appendRow([
      TextCellValue("Passed"),
      IntCellValue(summary.passedCount),
    ]);
    summarySheet.appendRow([
      TextCellValue("Failed"),
      IntCellValue(summary.failedCount),
    ]);
    summarySheet.appendRow([
      TextCellValue("Pass Rate"),
      TextCellValue("${summary.passRate.toStringAsFixed(1)}%"),
    ]);
    summarySheet.appendRow([
      TextCellValue("High Risk Alerts"),
      IntCellValue(summary.highRiskCount),
    ]);
    summarySheet.appendRow([
      TextCellValue("Resolved Alerts"),
      IntCellValue(summary.resolvedCount),
    ]);

    // ✅ Sheet 2: Inspections Table
    final tableSheet = excel['Inspections'];
    tableSheet.appendRow([
      TextCellValue("Product"),
      TextCellValue("Line"),
      TextCellValue("Temperature"),
      TextCellValue("Moisture"),
      TextCellValue("Result"),
      TextCellValue("Failure Reason"),
      TextCellValue("Date"),
    ]);

    for (final i in inspections) {
      final product = (i["productType"] ?? i["productName"] ?? "-").toString();
      final line = (i["line"] ?? i["productionLine"] ?? "-").toString();
      final temp = (i["temperature"] ?? 0).toString();
      final moist = (i["moisture"] ?? 0).toString();
      final res = (i["result"] ?? "-").toString();
      final reason = (i["failureReason"] ?? "-").toString();

      String dateText = "-";
      final createdAt = i["createdAt"];
      if (createdAt is Timestamp) {
        final dt = createdAt.toDate();
        dateText =
            "${dt.year}-${dt.month.toString().padLeft(2, "0")}-${dt.day.toString().padLeft(2, "0")} "
            "${dt.hour.toString().padLeft(2, "0")}:${dt.minute.toString().padLeft(2, "0")}";
      }

      tableSheet.appendRow([
        TextCellValue(product),
        TextCellValue(line),
        TextCellValue(temp),
        TextCellValue(moist),
        TextCellValue(res),
        TextCellValue(reason),
        TextCellValue(dateText),
      ]);
    }

    // ✅ Save file
    final dir = await getApplicationDocumentsDirectory();
    final now = DateTime.now();

    final safeTime =
        "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")}_${now.hour.toString().padLeft(2, "0")}${now.minute.toString().padLeft(2, "0")}";

    final filePath =
        "${dir.path}/QC_Report_${_rangeLabel(range)}_$safeTime.xlsx";

    final fileBytes = excel.save();
    final file = File(filePath);

    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);
    }

    return file;
  }

  /// ✅ Try open, if no app then Share
Future<bool> openFile(File file) async {
    final result = await OpenFilex.open(file.path);

    // بدل print (اختياري)
    debugPrint("OpenFilex result: ${result.type} - ${result.message}");

    // إذا ما في تطبيق يفتح الملف
    if (result.type == ResultType.noAppToOpen) {
      return false;
    }

    return result.type == ResultType.done;
  }


  String _rangeLabel(ReportsRange range) {
    switch (range) {
      case ReportsRange.today:
        return "Today";
      case ReportsRange.week:
        return "Last_7_Days";
      case ReportsRange.month:
        return "Last_Month";
    }
  }
}
