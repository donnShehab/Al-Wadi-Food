/// Canonical trace event types used across write-service, UI mapping, and validation.
///
/// Keep these stable to preserve audit trails and analytics.
class TraceEventTypes {
  TraceEventTypes._();

  // Core lifecycle
  static const String created = 'CREATED';
  static const String sentToQc = 'SENT_TO_QC';

  // QC
  static const String qcPassed = 'QC_PASSED';
  static const String qcFailed = 'QC_FAILED';

  // Manager decisions
  static const String approved = 'APPROVED';
  static const String rejected = 'REJECTED';
  static const String hold = 'HOLD';
}
