import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:alwadi_food/theme.dart';

class ImagesGrid extends StatelessWidget {
  final List<String> urls;

  const ImagesGrid({super.key, required this.urls});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: urls
          .map(
            (url) => CachedNetworkImage(
              imageUrl: url,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (_, __) => const CircularProgressIndicator(),
            ),
          )
          .toList(),
    );
  }
}
