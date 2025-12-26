import 'package:alwadi_food/presentation/qc/domain/entites/qc_report_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QCReportModel extends QCReportEntity {
  const QCReportModel({
    required super.reportId,
    required super.title,
    required super.pdfUrl,
    required super.weekStart,
    required super.weekEnd,
    required super.createdAt,
    required super.createdBy,
  });

  factory QCReportModel.fromJson(Map<String, dynamic> json) {
    return QCReportModel(
      reportId: json['reportId'],
      title: json['title'],
      pdfUrl: json['pdfUrl'],
      weekStart: (json['weekStart'] as Timestamp).toDate(),
      weekEnd: (json['weekEnd'] as Timestamp).toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "reportId": reportId,
      "title": title,
      "pdfUrl": pdfUrl,
      "weekStart": Timestamp.fromDate(weekStart),
      "weekEnd": Timestamp.fromDate(weekEnd),
      "createdAt": Timestamp.fromDate(createdAt),
      "createdBy": createdBy,
    };
  }

  factory QCReportModel.fromEntity(QCReportEntity entity) {
    return QCReportModel(
      reportId: entity.reportId,
      title: entity.title,
      pdfUrl: entity.pdfUrl,
      weekStart: entity.weekStart,
      weekEnd: entity.weekEnd,
      createdAt: entity.createdAt,
      createdBy: entity.createdBy,
    );
  }
}
