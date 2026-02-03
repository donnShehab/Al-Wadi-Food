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

    final Color statusColor = isPassed
        ? LightModeColors.lightSuccess
        : LightModeColors.lightError;

    final surface = theme.colorScheme.surface;
    final border = theme.colorScheme.onSurface.withOpacity(0.08);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),

          /// 🔗 NAVIGATION TO QC DETAILS (UNCHANGED)
          onTap: () {
            context.push('${AppRouter.KQCDetailsView}/${result.inspectionId}');
          },

          child: Row(
            children: [
              // ✅ Accent rail (ERP feel)
              Container(
                width: 6,
                height: 190,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.92),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== Header =====
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Inspector: ${result.inspectorName}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Executive status pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: statusColor.withOpacity(0.45),
                              ),
                            ),
                            child: Text(
                              result.result.toUpperCase(),
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // ===== Date =====
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.75),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Date: ${DateFormatter.formatDateTime(result.createdAt)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant
                                    .withOpacity(0.78),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),
                      Divider(height: 1, color: border),
                      const SizedBox(height: 14),

                      // ===== Metrics (ERP key/value table) =====
                      _metricRow(
                        context,
                        label: 'Temperature',
                        value: '${result.temperature} °C',
                      ),
                      _metricRow(
                        context,
                        label: 'Weight',
                        value: '${result.weight} kg',
                      ),
                      _metricRow(
                        context,
                        label: 'Moisture',
                        value: '${result.moisture} %',
                      ),
                      _metricRow(
                        context,
                        label: 'Packaging',
                        value: result.packaging,
                      ),
                      _metricRow(
                        context,
                        label: 'Texture',
                        value: result.texture,
                      ),

                      if (result.notes.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Notes',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface.withOpacity(
                              0.85,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          result.notes,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.25,
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.85),
                          ),
                        ),
                      ],

                      if (result.failureReason != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: statusColor.withOpacity(0.35),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Failure Reason',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: statusColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                result.failureReason!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: statusColor.withOpacity(0.95),
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UI-only helper
  Widget _metricRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface.withOpacity(0.82),
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
