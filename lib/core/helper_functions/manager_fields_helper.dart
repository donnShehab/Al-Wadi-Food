class ManagerFieldsHelper {
  /// ✅ FIX: Supports productType + productName + name + product
  static String productName(Map<String, dynamic> data) {
    final keys = [
      "productType",
      "productName",
      "name",
      "product", // ✅ IMPORTANT NEW KEY
    ];

    for (final k in keys) {
      final v = data[k];
      if (v != null && v.toString().trim().isNotEmpty) {
        return v.toString();
      }
    }
    return "Unknown Product";
  }

  /// ✅ Supports batchImages + images
  static String imageUrl(Map<String, dynamic> data) {
    final batchImages = data["batchImages"];
    if (batchImages is List && batchImages.isNotEmpty) {
      return batchImages.first.toString();
    }

    final images = data["images"];
    if (images is List && images.isNotEmpty) {
      return images.first.toString();
    }

    return "";
  }

  /// ✅ Supports line OR productionLine
  static String lineName(Map<String, dynamic> data) {
    return (data["line"] ?? data["productionLine"] ?? "-").toString();
  }
}
