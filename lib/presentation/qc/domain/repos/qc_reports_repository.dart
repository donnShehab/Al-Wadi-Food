import 'package:alwadi_food/presentation/qc/domain/entites/qc_report_entity.dart';
import 'package:dart_either/dart_either.dart';

abstract class QCReportsRepository {
  Future<Either<String, QCReportEntity>> generateWeeklyReport();
  Future<Either<String, List<QCReportEntity>>> getRecentReports();
}
