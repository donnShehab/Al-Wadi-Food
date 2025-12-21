import 'package:flutter/material.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/core/utils/date_formatter.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';

class QCDetailsHeader extends StatelessWidget {
  final QCResultEntity result;

  const QCDetailsHeader({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isPass = result.result == AppConstants.qcResultPass;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.inspectorName,
              style: Theme.of(context).textTheme.titleLarge?.semiBold,
            ),
            Text(
              DateFormatter.formatDateTime(result.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Chip(
          label: Text(
            result.result.toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: isPass
              ? LightModeColors.lightSuccess
              : LightModeColors.lightError,
        ),
      ],
    );
  }
}
