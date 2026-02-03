import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class QCMeasurementImages extends StatefulWidget {
  final List<File> images;
  final ValueChanged<File> onPickImage;

  const QCMeasurementImages({
    super.key,
    required this.images,
    required this.onPickImage,
  });

  @override
  State<QCMeasurementImages> createState() => _QCMeasurementImagesState();
}

class _QCMeasurementImagesState extends State<QCMeasurementImages> {
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        // NOTE: keep existing behavior (mutating the list here).
        widget.images.add(File(picked.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...widget.images.map(
          (img) => ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                Image.file(img, width: 92, height: 92, fit: BoxFit.cover),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.image,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.22),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo, color: theme.colorScheme.primary),
                const SizedBox(height: 6),
                Text(
                  'Add',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
