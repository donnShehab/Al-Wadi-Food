import 'package:alwadi_food/presentation/manager/traceability/domain/entities/trace_qc_result_entity.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_qc_evidence_card.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class TraceQcEvidenceSection extends StatelessWidget {
  final List<TraceQcResultEntity> qcResults;

  const TraceQcEvidenceSection({super.key, required this.qcResults});

  @override
  Widget build(BuildContext context) {
    if (qcResults.isEmpty) {
      return Container(
        padding: AppSpacing.paddingMd,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.18),
          ),
        ),
        child: Text(
          "No QC inspections found for this batch yet.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      );
    }

    return Column(
      children: qcResults.map((qc) => TraceQcEvidenceCard(qc: qc)).toList(),
    );
  }
}
