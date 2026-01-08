class TraceEventTypeMapper {
  static String toTitle(String type) {
    switch (type) {
      case "CREATED":
        return "Batch Created";
      case "SENT_TO_QC":
        return "Sent To QC";
      case "QC_PASSED":
        return "QC Passed";
      case "QC_FAILED":
        return "QC Failed";
      case "APPROVED":
        return "Approved";
      case "REJECTED":
        return "Rejected";
      default:
        return "Event";
    }
  }

  static String toIconName(String type) {
    switch (type) {
      case "CREATED":
        return "factory";
      case "SENT_TO_QC":
        return "send";
      case "QC_PASSED":
        return "check";
      case "QC_FAILED":
        return "close";
      case "APPROVED":
        return "verified";
      case "REJECTED":
        return "danger";
      default:
        return "info";
    }
  }
}
