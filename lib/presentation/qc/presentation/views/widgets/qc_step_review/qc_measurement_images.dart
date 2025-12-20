import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alwadi_food/theme.dart';

class QCMeasurementImages extends StatefulWidget {
  final List<File> images;
    final ValueChanged<File> onPickImage;

  const QCMeasurementImages({super.key, required this.images, required this.onPickImage});

  @override
  State<QCMeasurementImages> createState() => _QCMeasurementImagesState();
}

class _QCMeasurementImagesState extends State<QCMeasurementImages> {
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        widget.images.add(File(picked.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QC Evidence Images (Optional)',
          style: Theme.of(context).textTheme.titleMedium?.semiBold,
        ),
        const SizedBox(height: AppSpacing.sm),

        Wrap(
          spacing: AppSpacing.sm,
          children: [
            ...widget.images.map(
              (img) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  img,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            InkWell(
              onTap: _pickImage,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_a_photo),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
