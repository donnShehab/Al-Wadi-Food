class TraceAlertFilters {
  TraceAlertFilters._();

  static const String all = 'ALL';
  static const String critical = 'CRITICAL';
  static const String evidence = 'EVIDENCE';
  static const String sla = 'SLA';
  static const String ready = 'READY';
  static const String reviewed = 'REVIEWED';

  static const List<String> ordered = [
    all,
    critical,
    evidence,
    sla,
    ready,
    reviewed,
  ];

  static String label(String key) {
    switch (key) {
      case all:
        return 'All';
      case critical:
        return 'Critical';
      case evidence:
        return 'Evidence';
      case sla:
        return 'SLA';
      case ready:
        return 'Ready';
      case reviewed:
        return 'Reviewed';
      default:
        return key;
    }
  }
}
