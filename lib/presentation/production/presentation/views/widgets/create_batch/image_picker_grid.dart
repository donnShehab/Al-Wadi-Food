import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alwadi_food/theme.dart';

class ImagePickerGrid extends StatelessWidget {
  final List<File> images;
  final VoidCallback onChanged;

  const ImagePickerGrid({
    super.key,
    required this.images,
    required this.onChanged,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      images.add(File(pickedFile.path));
      onChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        ...images.map(
          (img) => Stack(
            children: [
              Image.file(img, width: 100, height: 100, fit: BoxFit.cover),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    images.remove(img);
                    onChanged();
                  },
                ),
              ),
            ],
          ),
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
    );
  }
}
