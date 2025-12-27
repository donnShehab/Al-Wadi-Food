import 'package:alwadi_food/presentation/qc/domain/entites/qc_report_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_reports_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'qc_reports_state.dart';

class QCReportsCubit extends Cubit<QCReportsState> {
  final QCReportsRepository _repository;

  QCReportsCubit(this._repository) : super(const QCReportsInitial());

  Future<void> loadRecentReports() async {
    emit(const QCReportsLoading());

    final result = await _repository.getRecentReports();
    result.fold(
      ifLeft: (failure) => emit(QCReportsError(failure)),
      ifRight: (reports) => emit(QCReportsLoaded(reports)),
    );
  }

  Future<void> generateWeeklyReport() async {
    emit(const QCReportsLoading());

    final result = await _repository.generateWeeklyReport();
    await result.fold(
      ifLeft: (failure) async => emit(QCReportsError(failure)),
      ifRight: (report) async {
        emit(QCReportGenerated(report, "Weekly report generated ✅"));
        await loadRecentReports();
      },
    );
  }

  Future<void> generateMonthlyReport() async {
    emit(const QCReportsLoading());

    final result = await _repository.generateMonthlyReport();
    await result.fold(
      ifLeft: (failure) async => emit(QCReportsError(failure)),
      ifRight: (report) async {
        emit(QCReportGenerated(report, "Monthly report generated ✅"));
        await loadRecentReports();
      },
    );
  }

  // ✅ NEW: Delete report
  Future<void> deleteReport(QCReportEntity report) async {
    emit(const QCReportsLoading());

    final result = await _repository.deleteReport(report);

    await result.fold(
      ifLeft: (failure) async => emit(QCReportsError(failure)),
      ifRight: (_) async {
        await loadRecentReports();
      },
    );
  }
}
