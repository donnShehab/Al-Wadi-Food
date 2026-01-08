import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/core/utils/date_formatter.dart';

class QCDetailsDecisionCard extends StatelessWidget {
  final QCResultEntity result;

  const QCDetailsDecisionCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hasFailure =
        result.failureReason != null && result.failureReason!.isNotEmpty;

    final hasAssigned =
        result.assignedQcName != null && result.assignedQcName!.isNotEmpty;

    final hasResolved = result.riskResolved == true;

    if (!hasFailure && !hasAssigned && !hasResolved) return const SizedBox();

    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: hasResolved
            ? Colors.green.withOpacity(0.08)
            : LightModeColors.lightError.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasResolved
              ? Colors.green.withOpacity(0.2)
              : LightModeColors.lightError.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ✅ Failure Reason
          if (hasFailure) ...[
            Row(
              children: [
                Icon(
                  Icons.report_gmailerrorred,
                  color: LightModeColors.lightError,
                ),
                const SizedBox(width: 8),
                Text(
                  'Failure Reason',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: LightModeColors.lightError,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              result.failureReason!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
          ],

          /// ✅ Assigned QC
          if (hasAssigned) ...[
            Row(
              children: [
                const Icon(Icons.person_add_alt_1, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  "Assigned QC",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "${result.assignedQcName} (${result.assignedQcId ?? ""})",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (result.assignedAt != null)
              Text(
                "Assigned at: ${DateFormatter.formatDateTime(result.assignedAt!)}",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            const SizedBox(height: 14),
          ],

          /// ✅ Resolved Info
          if (hasResolved) ...[
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  "Resolved ✅",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// ✅ Display real manager name
            _row("Resolved By", result.resolvedByName ?? "-"),
            const SizedBox(height: 8),

            _row(
              "Resolved At",
              result.resolvedAt != null
                  ? DateFormatter.formatDateTime(result.resolvedAt!)
                  : "-",
            ),

            if (result.resolveNote != null &&
                result.resolveNote!.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                "Resolve Note",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                result.resolveNote!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}
