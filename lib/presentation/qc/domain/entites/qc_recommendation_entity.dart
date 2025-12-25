import 'package:equatable/equatable.dart';

class QCRecommendation extends Equatable {
  final String title;
  final String description;
  final String severity; // low, medium, high
  final String action;

  const QCRecommendation({
    required this.title,
    required this.description,
    required this.severity,
    required this.action,
  });

  @override
  List<Object?> get props => [title, description, severity, action];
}
