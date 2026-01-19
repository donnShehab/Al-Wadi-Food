enum TraceNodeType {
  rawMaterial,
  productionBatch,
  qcInspection,
  inventoryLot,
  shipment,
}

extension TraceNodeTypeX on TraceNodeType {
  String get key {
    switch (this) {
      case TraceNodeType.rawMaterial:
        return 'RAW';
      case TraceNodeType.productionBatch:
        return 'PRODUCTION';
      case TraceNodeType.qcInspection:
        return 'QC';
      case TraceNodeType.inventoryLot:
        return 'INVENTORY';
      case TraceNodeType.shipment:
        return 'SHIPMENT';
    }
  }

  static TraceNodeType fromKey(String value) {
    switch (value.toUpperCase()) {
      case 'RAW':
        return TraceNodeType.rawMaterial;
      case 'PRODUCTION':
        return TraceNodeType.productionBatch;
      case 'QC':
        return TraceNodeType.qcInspection;
      case 'INVENTORY':
        return TraceNodeType.inventoryLot;
      case 'SHIPMENT':
        return TraceNodeType.shipment;
      default:
        throw ArgumentError('Unknown TraceNodeType: $value');
    }
  }
}
