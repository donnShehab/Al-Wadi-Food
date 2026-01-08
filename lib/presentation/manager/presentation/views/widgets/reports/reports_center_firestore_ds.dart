import 'package:alwadi_food/presentation/manager/domain/entities/reports_summary_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_line_comparison_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_failure_reason_entity.dart';
import 'package:alwadi_food/presentation/manager/domain/entities/reports_worst_line_insight_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';

enum ReportsRange { today, week, month }

class ReportsCenterFirestoreDataSource {
  final FirebaseFirestore firestore;

  ReportsCenterFirestoreDataSource(this.firestore);

  Map<String, DateTime> _getRangeDates(ReportsRange range) {
    final now = DateTime.now();
    DateTime start;

    switch (range) {
      case ReportsRange.today:
        start = DateTime(now.year, now.month, now.day);
        break;
      case ReportsRange.week:
        start = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: 6));
        break;
      case ReportsRange.month:
        start = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: 30));
        break;
    }

    return {"start": start, "end": now};
  }

  Future<List<Map<String, dynamic>>> fetchInspections(
    ReportsRange range,
  ) async {
    final dates = _getRangeDates(range);
    final start = dates["start"]!;
    final end = dates["end"]!;

    final snap = await firestore
        .collection(AppConstants.qcResultsCollection)
        .where("createdAt", isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where("createdAt", isLessThan: Timestamp.fromDate(end))
        .orderBy("createdAt", descending: true)
        .limit(50)
        .get();

    return snap.docs.map((d) => {"id": d.id, ...d.data()}).toList();
  }

  Future<ReportsSummaryEntity> fetchSummary(ReportsRange range) async {
    final inspections = await fetchInspections(range);

    final total = inspections.length;

    final passed = inspections.where((i) {
      final result = (i["result"] ?? i["qcResult"] ?? "").toString();
      final passedBool = i["passed"];
      if (result == AppConstants.qcResultPass) return true;
      if (passedBool is bool && passedBool == true) return true;
      return false;
    }).length;

    final failed = inspections.where((i) {
      final result = (i["result"] ?? i["qcResult"] ?? "").toString();
      final passedBool = i["passed"];
      if (result == AppConstants.qcResultFail) return true;
      if (passedBool is bool && passedBool == false) return true;
      return false;
    }).length;

    final highRisk = inspections.where((i) {
      final temp = (i["temperature"] ?? 0).toDouble();
      final moisture = (i["moisture"] ?? 0).toDouble();
      return temp > 10 || moisture > 15;
    }).length;

    final resolvedCount = inspections
        .where((i) => i["riskResolved"] == true)
        .length;

    return ReportsSummaryEntity(
      totalInspections: total,
      passedCount: passed,
      failedCount: failed,
      highRiskCount: highRisk,
      resolvedCount: resolvedCount,
    );
  }

  Future<List<ReportsLineComparisonEntity>> fetchLinesComparison(
    ReportsRange range,
  ) async {
    final inspections = await fetchInspections(range);

    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final i in inspections) {
      final line = (i["line"] ?? i["productionLine"] ?? "Unknown").toString();
      grouped.putIfAbsent(line, () => []);
      grouped[line]!.add(i);
    }

    final List<ReportsLineComparisonEntity> result = [];

    grouped.forEach((lineName, list) {
      final total = list.length;

      final passed = list.where((i) {
        final res = (i["result"] ?? i["qcResult"] ?? "").toString();
        final passedBool = i["passed"];
        if (res == AppConstants.qcResultPass) return true;
        if (passedBool is bool && passedBool == true) return true;
        return false;
      }).length;

      final failed = list.where((i) {
        final res = (i["result"] ?? i["qcResult"] ?? "").toString();
        final passedBool = i["passed"];
        if (res == AppConstants.qcResultFail) return true;
        if (passedBool is bool && passedBool == false) return true;
        return false;
      }).length;

      final highRisk = list.where((i) {
        final temp = (i["temperature"] ?? 0).toDouble();
        final moisture = (i["moisture"] ?? 0).toDouble();
        return temp > 10 || moisture > 15;
      }).length;

      result.add(
        ReportsLineComparisonEntity(
          lineName: lineName,
          total: total,
          passed: passed,
          failed: failed,
          highRisk: highRisk,
        ),
      );
    });

    result.sort((a, b) => b.passRate.compareTo(a.passRate));
    return result;
  }

  Future<List<ReportsFailureReasonEntity>> fetchTopFailureReasons(
    ReportsRange range,
  ) async {
    final inspections = await fetchInspections(range);

    final Map<String, int> reasonsCount = {};

    for (final i in inspections) {
      final reason = (i["failureReason"] ?? "").toString().trim();
      final result = (i["result"] ?? i["qcResult"] ?? "").toString();

      if (result == AppConstants.qcResultFail && reason.isNotEmpty) {
        reasonsCount[reason] = (reasonsCount[reason] ?? 0) + 1;
      }
    }

    final sorted = reasonsCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(5).map((e) {
      return ReportsFailureReasonEntity(reason: e.key, count: e.value);
    }).toList();
  }

  // ============================================================
  // ✅ NEW: Worst Line Insight (WHY)
  // ============================================================
  Future<ReportsWorstLineInsightEntity?> fetchWorstLineInsight(
    ReportsRange range,
  ) async {
    final inspections = await fetchInspections(range);
    if (inspections.isEmpty) return null;

    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final i in inspections) {
      final line = (i["line"] ?? i["productionLine"] ?? "Unknown").toString();
      grouped.putIfAbsent(line, () => []);
      grouped[line]!.add(i);
    }

    ReportsWorstLineInsightEntity? worst;

    grouped.forEach((lineName, list) {
      final total = list.length;

      final passed = list.where((i) {
        final res = (i["result"] ?? i["qcResult"] ?? "").toString();
        final passedBool = i["passed"];
        if (res == AppConstants.qcResultPass) return true;
        if (passedBool is bool && passedBool == true) return true;
        return false;
      }).length;

      final failed = list.where((i) {
        final res = (i["result"] ?? i["qcResult"] ?? "").toString();
        final passedBool = i["passed"];
        if (res == AppConstants.qcResultFail) return true;
        if (passedBool is bool && passedBool == false) return true;
        return false;
      }).length;

      final highRisk = list.where((i) {
        final temp = (i["temperature"] ?? 0).toDouble();
        final moisture = (i["moisture"] ?? 0).toDouble();
        return temp > 10 || moisture > 15;
      }).length;

      final passRate = total == 0 ? 0.0 : (passed / total) * 100;

      /// ✅ collect failure reasons INSIDE THIS LINE
      final Map<String, int> reasonsMap = {};

      for (final i in list) {
        final reason = (i["failureReason"] ?? "").toString().trim();
        final result = (i["result"] ?? i["qcResult"] ?? "").toString();

        if (result == AppConstants.qcResultFail && reason.isNotEmpty) {
          reasonsMap[reason] = (reasonsMap[reason] ?? 0) + 1;
        }
      }

      final sortedReasons = reasonsMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final topReasons = sortedReasons.take(3).map((e) {
        return {"reason": e.key, "count": e.value};
      }).toList();

    final current = ReportsWorstLineInsightEntity(
        lineName: lineName,
        total: total,
        passed: passed,
        failed: failed,
        highRisk: highRisk,
        passRate: passRate,
        topReasons: topReasons,
      );

      if (worst == null || current.passRate < worst!.passRate) {
        worst = current;
      }
    });

    return worst;
  }
}
