import 'dart:developer';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/auth/data/services/firestore_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/qc_pdf_report_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/storage_service.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:alwadi_food/presentation/qc/data/models/qc_report_model.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_report_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_reports_repository.dart';
import 'package:dart_either/dart_either.dart';

class QCReportsRepositoryImpl implements QCReportsRepository {
  final FirestoreService _firestoreService;
  final StorageService _storageService;
  final AuthRepository _authRepository;
  final QCRepository _qcRepository;
  final QCPdfReportService _pdfService;

  QCReportsRepositoryImpl(
    this._firestoreService,
    this._storageService,
    this._authRepository,
    this._qcRepository,
    this._pdfService,
  );

  // ============================================================
  // ✅ Weekly Report
  // ============================================================
  @override
  Future<Either<String, QCReportEntity>> generateWeeklyReport() async {
    try {
      final uid = _authRepository.getCurrentUserId();
      if (uid == null) return const Left("User not authenticated");

      final now = DateTime.now();
      final weekEnd = now;
      final weekStart = now.subtract(const Duration(days: 7));

      final resultsEither = await _qcRepository.getAllQCResults();

      return await resultsEither.fold(
        ifLeft: (failure) async => Left(failure.message),
        ifRight: (results) async {
          final rangeResults = results
              .where((r) => r.createdAt.isAfter(weekStart))
              .toList();

          final passed = rangeResults
              .where((e) => e.result == AppConstants.qcResultPass)
              .length;

          final failed = rangeResults
              .where((e) => e.result == AppConstants.qcResultFail)
              .length;

          final total = passed + failed;
          final passRate = total == 0 ? 100 : (passed / total) * 100;

          final riskLevel = passRate < 60
              ? "HIGH"
              : passRate < 80
              ? "MEDIUM"
              : "LOW";

          final failureReasons = rangeResults
              .where((e) => e.result == AppConstants.qcResultFail)
              .map((e) => e.failureReason ?? "Unknown")
              .toList();

          final recommendations = [
            if (failed > 0) "Investigate top failure patterns",
            if (riskLevel == "HIGH") "Immediate corrective actions required",
            if (riskLevel == "MEDIUM") "Monitor production closely",
            if (failed == 0) "Maintain SOP and continue monitoring",
          ];

          // ✅ Daily Activity
          final dailyRows = _buildDailySummary(rangeResults);

          // ✅ Leaderboard
          final leaderboardRows = _buildLeaderboard(rangeResults);

          final pdfBytes = await _pdfService.generateWeeklyPdf(
            companyName: "Alwadi Food Factory",
            weekStart: weekStart,
            weekEnd: weekEnd,
            totalInspections: total,
            passed: passed,
            failed: failed,
            riskLevel: riskLevel,
            topFailures: failureReasons,
            recommendations: recommendations,
            dailyRows: dailyRows,
            leaderboardRows: leaderboardRows,
          );

          final reportId = DateTime.now().millisecondsSinceEpoch.toString();

          final pdfUrl = await _storageService.uploadBytes(
            "${AppConstants.qcReportsPath}/$reportId.pdf",
            pdfBytes,
          );

          final title =
              "QC Weekly Report (${weekStart.day}/${weekStart.month} - ${weekEnd.day}/${weekEnd.month})";

          final reportEntity = QCReportEntity(
            reportId: reportId,
            title: title,
            pdfUrl: pdfUrl,
            weekStart: weekStart,
            weekEnd: weekEnd,
            createdAt: DateTime.now(),
            createdBy: uid,
          );

          await _firestoreService.createDocument(
            AppConstants.qcReportsCollection,
            reportId,
            QCReportModel.fromEntity(reportEntity).toJson(),
          );

          return Right(reportEntity);
        },
      );
    } catch (e) {
      log("generateWeeklyReport error: $e");
      return Left("Failed to generate weekly report: $e");
    }
  }

  // ============================================================
  // ✅ Monthly Report
  // ============================================================
  @override
  Future<Either<String, QCReportEntity>> generateMonthlyReport() async {
    try {
      final uid = _authRepository.getCurrentUserId();
      if (uid == null) return const Left("User not authenticated");

      final now = DateTime.now();
      final monthStart = DateTime(now.year, now.month, 1);
      final monthEnd = now;

      final resultsEither = await _qcRepository.getAllQCResults();

      return await resultsEither.fold(
        ifLeft: (failure) async => Left(failure.message),
        ifRight: (results) async {
          final rangeResults = results
              .where((r) => r.createdAt.isAfter(monthStart))
              .toList();

          final passed = rangeResults
              .where((e) => e.result == AppConstants.qcResultPass)
              .length;

          final failed = rangeResults
              .where((e) => e.result == AppConstants.qcResultFail)
              .length;

          final total = passed + failed;
          final passRate = total == 0 ? 100 : (passed / total) * 100;

          final riskLevel = passRate < 60
              ? "HIGH"
              : passRate < 80
              ? "MEDIUM"
              : "LOW";

          final failureReasons = rangeResults
              .where((e) => e.result == AppConstants.qcResultFail)
              .map((e) => e.failureReason ?? "Unknown")
              .toList();

          final recommendations = [
            if (failed > 0) "Investigate major failure patterns for this month",
            if (riskLevel == "HIGH")
              "Immediate corrective actions required this month",
            if (riskLevel == "MEDIUM") "Monitor production closely this month",
            if (failed == 0) "Maintain SOP and continue monitoring",
          ];

          final dailyRows = _buildDailySummary(rangeResults);
          final leaderboardRows = _buildLeaderboard(rangeResults);

          final pdfBytes = await _pdfService.generateMonthlyPdf(
            companyName: "Alwadi Food Factory",
            monthStart: monthStart,
            monthEnd: monthEnd,
            totalInspections: total,
            passed: passed,
            failed: failed,
            riskLevel: riskLevel,
            topFailures: failureReasons,
            recommendations: recommendations,
            dailyRows: dailyRows,
            leaderboardRows: leaderboardRows,
          );

          final reportId = DateTime.now().millisecondsSinceEpoch.toString();

          final pdfUrl = await _storageService.uploadBytes(
            "${AppConstants.qcReportsPath}/$reportId.pdf",
            pdfBytes,
          );

          final title =
              "QC Monthly Report (${monthStart.month}/${monthStart.year})";

          final reportEntity = QCReportEntity(
            reportId: reportId,
            title: title,
            pdfUrl: pdfUrl,
            weekStart: monthStart,
            weekEnd: monthEnd,
            createdAt: DateTime.now(),
            createdBy: uid,
          );

          await _firestoreService.createDocument(
            AppConstants.qcReportsCollection,
            reportId,
            QCReportModel.fromEntity(reportEntity).toJson(),
          );

          return Right(reportEntity);
        },
      );
    } catch (e) {
      log("generateMonthlyReport error: $e");
      return Left("Failed to generate monthly report: $e");
    }
  }

  // ============================================================
  // ✅ Recent Reports
  // ============================================================
  @override
  Future<Either<String, List<QCReportEntity>>> getRecentReports() async {
    try {
      final snapshot = await _firestoreService.queryCollection(
        AppConstants.qcReportsCollection,
        orderBy: "createdAt",
        descending: true,
      );

      final reports = snapshot.docs
          .map(
            (doc) => QCReportModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();

      return Right(reports);
    } catch (e) {
      return Left("Failed to load reports: $e");
    }
  }

  // ============================================================
  // ✅ Delete Report
  // ============================================================
  @override
  Future<Either<String, void>> deleteReport(QCReportEntity report) async {
    try {
      await _storageService.deleteFile(report.pdfUrl);
      await _firestoreService.deleteDocument(
        AppConstants.qcReportsCollection,
        report.reportId,
      );
      return const Right(null);
    } catch (e) {
      return Left("Failed to delete report: $e");
    }
  }

  // ============================================================
  // ✅ Helpers: Daily Activity Summary
  // ============================================================
  List<QCDailySummaryRow> _buildDailySummary(List results) {
final Map<String, List<dynamic>> dayMap = {};

    for (final r in results) {
      final d = DateTime(r.createdAt.year, r.createdAt.month, r.createdAt.day);
      final key = d.toIso8601String();
      dayMap.putIfAbsent(key, () => []);
      dayMap[key]!.add(r);
    }

    final rows = <QCDailySummaryRow>[];

    for (final entry in dayMap.entries) {
      final day = DateTime.parse(entry.key);
      final list = entry.value;

      final passed = list
          .where((e) => e.result == AppConstants.qcResultPass)
          .length;

      final failed = list
          .where((e) => e.result == AppConstants.qcResultFail)
          .length;

     final List<String> reasons = list
          .where((e) => e.result == AppConstants.qcResultFail)
          .map((e) => (e.failureReason ?? "Unknown").toString())
          .toList();

final topFailure = _topFailure(reasons);

      rows.add(
        QCDailySummaryRow(
          day: day,
          total: list.length,
          passed: passed,
          failed: failed,
          topFailure: topFailure,
        ),
      );
    }

    rows.sort((a, b) => a.day.compareTo(b.day));
    return rows;
  }

  String _topFailure(List<String> reasons) {
    if (reasons.isEmpty) return "-";

    final map = <String, int>{};
    for (final r in reasons) {
      map[r] = (map[r] ?? 0) + 1;
    }

    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }

  // ============================================================
  // ✅ Helpers: Leaderboard
  // ============================================================
  List<QCLeaderboardRow> _buildLeaderboard(List results) {
    final Map<String, Map<String, dynamic>> map = {};

    for (final r in results) {
      final id = r.inspectorId;
      final name = r.inspectorName;

      map.putIfAbsent(
        id,
        () => {"name": name, "total": 0, "passed": 0, "failed": 0},
      );

      map[id]!["total"]++;
      if (r.result == AppConstants.qcResultPass) map[id]!["passed"]++;
      if (r.result == AppConstants.qcResultFail) map[id]!["failed"]++;
    }

    final list = map.entries.map((e) {
      final total = e.value["total"] as int;
      final passed = e.value["passed"] as int;
      final failed = e.value["failed"] as int;
      final passRate = total == 0 ? 0 : (passed / total) * 100;

      return QCLeaderboardRow(
        rank: 0,
        inspector: e.value["name"],
        total: total,
        passed: passed,
        failed: failed,
        passRate: passRate.toDouble(),
      );
    }).toList();

    list.sort((a, b) => b.passRate.compareTo(a.passRate));

    for (int i = 0; i < list.length; i++) {
      list[i] = QCLeaderboardRow(
        rank: i + 1,
        inspector: list[i].inspector,
        total: list[i].total,
        passed: list[i].passed,
        failed: list[i].failed,
        passRate: list[i].passRate,
      );
    }

    return list;
  }
}
