import 'package:alwadi_food/presentation/qc/domain/repos/qc_reports_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'qc_reports_state.dart';

class QCReportsCubit extends Cubit<QCReportsState> {
  final QCReportsRepository _repository;

  QCReportsCubit(this._repository) : super(const QCReportsInitial());

  // ✅ Load recent reports
  Future<void> loadRecentReports() async {
    emit(const QCReportsLoading());

    final result = await _repository.getRecentReports();
    result.fold(
      ifLeft: (failure) => emit(QCReportsError(failure)),
      ifRight: (reports) => emit(QCReportsLoaded(reports)),
    );
  }

  // ✅ Generate weekly report
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
}
