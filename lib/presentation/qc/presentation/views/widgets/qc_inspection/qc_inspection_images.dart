import 'dart:io';
import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';
import 'package:image_picker/image_picker.dart';

class QCInspectionImages extends StatelessWidget {
  final List<File> images;
  final Function(File) onPickImage;

  const QCInspectionImages({
    super.key,
    required this.images,
    required this.onPickImage,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) onPickImage(File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('QC Images', style: theme.textTheme.labelLarge?.semiBold),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            ...images.map(
              (img) =>
                  Image.file(img, width: 100, height: 100, fit: BoxFit.cover),
            ),
            InkWell(
              onTap: () => _pickImage(context),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.add_photo_alternate, size: 32),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
