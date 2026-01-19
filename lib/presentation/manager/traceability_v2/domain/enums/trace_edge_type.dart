enum TraceEdgeType {
  consumedIn,
  producedFrom,
  storedAs,
  shippedAs,
  processLoss,
}

  

extension TraceEdgeTypeX on TraceEdgeType {
  String get key {
    switch (this) {
      case TraceEdgeType.consumedIn:
        return 'CONSUMED_IN';
      case TraceEdgeType.producedFrom:
        return 'PRODUCED_FROM';
      case TraceEdgeType.storedAs:
        return 'STORED_AS';
      case TraceEdgeType.shippedAs:
        return 'SHIPPED_AS';
      case TraceEdgeType.processLoss:
        return 'PROCESS_LOSS';
    }
  }

  static TraceEdgeType fromKey(String value) {
    switch (value.toUpperCase()) {
      case 'CONSUMED_IN':
        return TraceEdgeType.consumedIn;
      case 'PRODUCED_FROM':
        return TraceEdgeType.producedFrom;
      case 'STORED_AS':
        return TraceEdgeType.storedAs;
      case 'SHIPPED_AS':
        return TraceEdgeType.shippedAs;
      case 'PROCESS_LOSS':
        return TraceEdgeType.processLoss;
      default:
        throw ArgumentError('Unknown TraceEdgeType: $value');
    }
  }
}
