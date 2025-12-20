import 'package:alwadi_food/presentation/qc/domain/entites/qc_measurements_entity.dart';

enum QCRiskLevel { low, medium, high }

class QCRiskEvaluator {
  static QCRiskLevel evaluate(QCMeasurementsEntity m) {
    if (m.temperature > 10 || m.moisture > 15) {
      return QCRiskLevel.high;
    }

    if (m.temperature > 7 || m.moisture > 12) {
      return QCRiskLevel.medium;
    }

    return QCRiskLevel.low;
  }

  static String label(QCRiskLevel level) {
    switch (level) {
      case QCRiskLevel.low:
        return 'Low Risk';
      case QCRiskLevel.medium:
        return 'Medium Risk';
      case QCRiskLevel.high:
        return 'High Risk';
    }
  }
}
