// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:alwadi_food/theme.dart';
// import 'package:image_picker/image_picker.dart';

// class QCInspectionImages extends StatelessWidget {
//   final List<File> images;
//   final Function(File) onPickImage;

//   const QCInspectionImages({
//     super.key,
//     required this.images,
//     required this.onPickImage,
//   });

//   Future<void> _pickImage(BuildContext context) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) onPickImage(File(pickedFile.path));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('QC Images', style: theme.textTheme.labelLarge?.semiBold),
//         const SizedBox(height: AppSpacing.sm),
//         Wrap(
//           spacing: AppSpacing.sm,
//           children: [
//             ...images.map(
//               (img) =>
//                   Image.file(img, width: 100, height: 100, fit: BoxFit.cover),
//             ),
//             InkWell(
//               onTap: () => _pickImage(context),
//               child: Container(
//                 width: 100,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: theme.colorScheme.outline),
//                   borderRadius: BorderRadius.circular(AppRadius.sm),
//                 ),
//                 child: const Icon(Icons.add_photo_alternate, size: 32),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:alwadi_food/theme.dart';

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
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      onPickImage(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Text(
          'Inspection Images',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        /// Images grid
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ...images.map(
              (img) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  img,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// Add image button
            InkWell(
              onTap: () => _pickImage(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.6),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surface,
                ),
                child: Icon(
                  Icons.add_a_photo,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        /// Hint
        Text(
          'Images are optional but recommended for failed inspections.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
