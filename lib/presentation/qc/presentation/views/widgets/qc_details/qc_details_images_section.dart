import 'package:flutter/material.dart';

class QCDetailsImagesSection extends StatelessWidget {
  final List<String> images;

  const QCDetailsImagesSection({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const Text('No inspection images provided');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: images
          .map(
            (url) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                url,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          )
          .toList(),
    );
  }
}
