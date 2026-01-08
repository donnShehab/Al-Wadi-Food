import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class TraceImageGallery extends StatelessWidget {
  final List<String> imageUrls;

  const TraceImageGallery({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (imageUrls.isEmpty) {
      return Text(
        "No images attached.",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface.withOpacity(0.7),
        ),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: imageUrls.map((url) {
        return GestureDetector(
          onTap: () => _open(context, url),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Image.network(
              url,
              width: 92,
              height: 92,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 92,
                height: 92,
                color: scheme.surfaceContainerHighest.withOpacity(0.6),
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image_rounded,
                  color: scheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _open(BuildContext context, String url) {
    final scheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Stack(
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    height: 320,
                    alignment: Alignment.center,
                    child: const Text("Image failed to load"),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
