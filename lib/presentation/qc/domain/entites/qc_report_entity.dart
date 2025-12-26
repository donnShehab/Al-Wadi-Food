import 'package:equatable/equatable.dart';

class QCReportEntity extends Equatable {
  final String reportId;
  final String title;
  final String pdfUrl;
  final DateTime weekStart;
  final DateTime weekEnd;
  final DateTime createdAt;
  final String createdBy;

  const QCReportEntity({
    required this.reportId,
    required this.title,
    required this.pdfUrl,
    required this.weekStart,
    required this.weekEnd,
    required this.createdAt,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
    reportId,
    title,
    pdfUrl,
    weekStart,
    weekEnd,
    createdAt,
    createdBy,
  ];
}
