import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/images_grid.dart';

class ProductionImagesSection extends StatelessWidget {
  final List<String> imageUrls;

  const ProductionImagesSection({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Section Title
          Text(
            'Production Images',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),

          /// 🔹 Images
          imageUrls.isNotEmpty
              ? ImagesGrid(urls: imageUrls)
              : Text(
                  'No production images available.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
        ],
      ),
    );
  }
}
