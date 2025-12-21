import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';

import 'qc_details_header.dart';
import 'qc_details_measurements_card.dart';
import 'qc_details_images_section.dart';
import 'qc_details_decision_card.dart';

class QCDetailsViewBody extends StatelessWidget {
  final QCResultEntity result;

  const QCDetailsViewBody({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QCDetailsHeader(result: result),
          const SizedBox(height: 24),

          QCDetailsMeasurementsCard(result: result),
          const SizedBox(height: 24),

          QCDetailsImagesSection(images: result.images),
          const SizedBox(height: 24),

          QCDetailsDecisionCard(result: result),
        ],
      ),
    );
  }
}
