class TraceRiskResult {
  final int score; // 0..100
  final String label; // HIGH / MEDIUM / LOW
  final List<String> reasons;

  const TraceRiskResult({
    required this.score,
    required this.label,
    required this.reasons,
  });
}

class TraceRiskEngine {
  TraceRiskEngine._();

  /// Deterministic rules (cap at 100):
  /// - failed +50
  /// - failed & missing failureReason +15
  /// - failed & total images == 0 +20
  /// - waiting_qc & age >= 12h +15
  /// - waiting_qc & age >= 6h +8
  static TraceRiskResult compute({
    required String status,
    required DateTime createdAt,
    required int totalImages,
    required bool missingFailureReason,
  }) {
    int score = 0;
    final reasons = <String>[];

    if (status == 'failed') {
      score += 50;
      reasons.add('+50 QC failed');
      if (missingFailureReason) {
        score += 15;
        reasons.add('+15 Missing failure reason');
      }
      if (totalImages == 0) {
        score += 20;
        reasons.add('+20 Missing images');
      }
    }

    if (status == 'waiting_qc') {
      final ageHours = DateTime.now().difference(createdAt).inHours;
      if (ageHours >= 12) {
        score += 15;
        reasons.add('+15 Waiting QC ≥ 12h (SLA critical)');
      } else if (ageHours >= 6) {
        score += 8;
        reasons.add('+8 Waiting QC ≥ 6h (SLA warning)');
      }
    }

    if (score > 100) score = 100;
    if (score < 0) score = 0;

    final label = score >= 70
        ? 'HIGH'
        : score >= 35
        ? 'MEDIUM'
        : 'LOW';

    return TraceRiskResult(score: score, label: label, reasons: reasons);
  }
}
