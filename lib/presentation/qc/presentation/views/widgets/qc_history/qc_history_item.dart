import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/core/utils/date_formatter.dart';
import 'package:alwadi_food/core/router/app_router.dart';
import 'package:alwadi_food/theme.dart';

class QCHistoryItem extends StatelessWidget {
  final QCResultEntity result;

  const QCHistoryItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isPassed = result.result == AppConstants.qcResultPass;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),

        /// 🔗 NAVIGATION TO QC DETAILS
        onTap: () {
          context.push('${AppRouter.KQCDetailsView}/${result.inspectionId}');
        },

        child: Padding(
          padding: AppSpacing.paddingMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ─── HEADER ─────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Inspector: ${result.inspectorName}',
                    style: theme.textTheme.titleMedium?.semiBold,
                  ),
                  Chip(
                    label: Text(
                      result.result.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: isPassed
                        ? LightModeColors.lightSuccess
                        : LightModeColors.lightError,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              /// ─── DATE ───────────────────────────────────────
              Text(
                'Date: ${DateFormatter.formatDateTime(result.createdAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const Divider(height: 24),

              /// ─── MEASUREMENTS ──────────────────────────────
              _row('Temperature', '${result.temperature} °C'),
              _row('Weight', '${result.weight} kg'),
              _row('Moisture', '${result.moisture} %'),
              _row('Packaging', result.packaging),
              _row('Texture', result.texture),

              if (result.notes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text('Notes:', style: theme.textTheme.bodyMedium?.semiBold),
                Text(result.notes),
              ],

              if (result.failureReason != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Failure Reason:',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: LightModeColors.lightError,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  result.failureReason!,
                  style: TextStyle(color: LightModeColors.lightError),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// ─── Helper Row ───────────────────────────────────────
  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
