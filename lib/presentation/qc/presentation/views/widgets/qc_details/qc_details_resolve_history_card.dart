import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:alwadi_food/core/utils/date_formatter.dart';

class QCDetailsResolveHistoryCard extends StatelessWidget {
  final QCResultEntity result;

  const QCDetailsResolveHistoryCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hasResolved = result.riskResolved == true;
    if (!hasResolved) return const SizedBox();

    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ✅ Title
          Row(
            children: [
              const Icon(Icons.history_rounded, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                "Resolve History",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _row("Resolved By", result.resolvedById ?? "-"),
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
              style: const TextStyle(fontWeight: FontWeight.w600, height: 1.4),
            ),
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
