import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/images_grid.dart';

class ImagesSection extends StatelessWidget {
  final List<String> images;

  const ImagesSection({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Images",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),

        images.isNotEmpty
            ? ImagesGrid(urls: images)
            : Text(
                "No images available",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
      ],
    );
  }
}
