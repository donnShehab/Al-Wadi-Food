import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';

class TraceFallbacks {
  static String productFromBatch(ProductionBatchEntity batch) {
    // batch.product is the canonical field in your app.
    try {
      final v = batch.product.trim();
      return v.isEmpty ? '-' : v;
    } catch (_) {
      return '-';
    }
  }

  static String? thumbnailFromBatch(ProductionBatchEntity batch) {
    // ✅ ProductionBatchEntity does NOT contain imageUrl in your codebase.
    // Use only existing fields. Primary source: images.first (if available).
    try {
      final imgs = batch.images;
      if (imgs.isNotEmpty) {
        final first = imgs.first.trim();
        return first.isEmpty ? null : first;
      }
    } catch (_) {}

    // If no images exist, return null safely.
    return null;
  }

  /// Human friendly time-ago string for manager screens.
  /// Example: "3m ago", "2h ago", "Yesterday", "5d ago".
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }
}
