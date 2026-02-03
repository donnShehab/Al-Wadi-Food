import 'package:flutter/material.dart';
import 'package:alwadi_food/theme.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'qc_history_item.dart';

class QCHistoryViewBody extends StatelessWidget {
  final List<QCResultEntity> results;

  const QCHistoryViewBody({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No QC inspections found',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withOpacity(0.75),
          ),
        ),
      );
    }

    return DecoratedBox(
      // ✅ Executive background (UI only)
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.25,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.primary.withOpacity(0.035),
          ],
        ),
      ),
      child: ListView.builder(
        padding: AppSpacing.paddingLg,
        itemCount: results.length,
        itemBuilder: (context, index) {
          return QCHistoryItem(result: results[index]);
        },
      ),
    );
  }
}
