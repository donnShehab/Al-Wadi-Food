class ProductCatalog {
  // ✅ رجع مسار صورة افتراضية لكل Product Type
  // الأفضل: تحط صور داخل assets (أحسن UX وأسرع)
  static const Map<String, String> productAsset = {
    'Burger': 'assets/products/burger.png',
    'Nuggets': 'assets/products/nuggets.png',
    'Escalope': 'assets/products/escalope.png',
    'Luncheon': 'assets/products/luncheon.png',
    'Chicken Strips': 'assets/products/strips.png',
    'Meatballs': 'assets/products/meatballs.png',
    'Zinger': 'assets/products/zinger.png',
    'Hot Dog': 'assets/products/hotdog.png',
    'Sausage': 'assets/products/sausage.png',
  };

  static String? assetFor(String? productType) {
    if (productType == null) return null;
    return productAsset[productType];
  }
}
