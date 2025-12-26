import 'dart:developer';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/auth/data/services/firestore_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/qc_pdf_report_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/storage_service.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_report_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_reports_repository.dart';
import 'package:alwadi_food/presentation/qc/data/models/qc_report_model.dart';
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

  @override
  Future<Either<String, QCReportEntity>> generateWeeklyReport() async {
    try {
      final user = await _authRepository.getCurrentUser();
      final uid = _authRepository.getCurrentUserId();

      if (uid == null) return const Left("User not authenticated");

      final now = DateTime.now();
      final weekEnd = now;
      final weekStart = now.subtract(const Duration(days: 7));

      /// ✅ Get all QC results
      final resultsEither = await _qcRepository.getAllQCResults();

      return await resultsEither.fold(
        ifLeft: (failure) async => Left(failure.message),
        ifRight: (results) async {
          final lastWeek = results
              .where((r) => r.createdAt.isAfter(weekStart))
              .toList();

          final passed = lastWeek
              .where((e) => e.result == AppConstants.qcResultPass)
              .length;

          final failed = lastWeek
              .where((e) => e.result == AppConstants.qcResultFail)
              .length;

          final total = passed + failed;
          final riskLevel = total == 0
              ? "LOW"
              : (passed / total) * 100 < 60
                  ? "HIGH"
                  : (passed / total) * 100 < 80
                      ? "MEDIUM"
                      : "LOW";

          final topFailures = lastWeek
              .where((e) => e.result == AppConstants.qcResultFail)
              .map((e) => e.failureReason ?? "Unknown")
              .toList();

          final recommendations = [
            if (failed > 0) "Investigate top failure patterns",
            if (riskLevel == "HIGH") "Immediate corrective actions required",
            if (riskLevel == "MEDIUM") "Monitor production closely",
            if (failed == 0) "Maintain SOP and continue monitoring",
          ];

          final pdfBytes = await _pdfService.generateWeeklyPdf(
            companyName: "Alwadi Food Factory",
            weekStart: weekStart,
            weekEnd: weekEnd,
            totalInspections: total,
            passed: passed,
            failed: failed,
            riskLevel: riskLevel,
            topFailures: topFailures.take(5).toList(),
            recommendations: recommendations,
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

  @override
  Future<Either<String, List<QCReportEntity>>> getRecentReports() async {
    try {
      final snapshot = await _firestoreService.queryCollection(
        AppConstants.qcReportsCollection,
        orderBy: "createdAt",
        descending: true,
      );

      final reports = snapshot.docs
          .map((doc) =>
              QCReportModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return Right(reports);
    } catch (e) {
      return Left("Failed to load reports: $e");
    }
  }
}
