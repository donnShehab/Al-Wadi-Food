import 'package:alwadi_food/presentation/qc/domain/entites/qc_report_entity.dart';
import 'package:equatable/equatable.dart';

sealed class QCReportsState extends Equatable {
  const QCReportsState();

  @override
  List<Object?> get props => [];
}

class QCReportsInitial extends QCReportsState {
  const QCReportsInitial();
}

class QCReportsLoading extends QCReportsState {
  const QCReportsLoading();
}

class QCReportsLoaded extends QCReportsState {
  final List<QCReportEntity> reports;

  const QCReportsLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

class QCReportGenerated extends QCReportsState {
  final QCReportEntity report;
  final String message;

  const QCReportGenerated(this.report, this.message);

  @override
  List<Object?> get props => [report, message];
}

class QCReportsError extends QCReportsState {
  final String message;

  const QCReportsError(this.message);

  @override
  List<Object?> get props => [message];
}
