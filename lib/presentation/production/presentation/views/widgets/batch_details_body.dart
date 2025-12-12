import 'package:alwadi_food/presentation/production/cubit/production_state.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/batch_actions.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/batch_header_card.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/images_section.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/production_info_section.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/status_time_line.dart';
import 'package:alwadi_food/presentation/production/presentation/views/widgets/batch_details/time_tracking_section.dart';
import 'package:alwadi_food/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class BatchDetailsBody extends StatelessWidget {
  final ProductionState state;
  final String batchId;

  const BatchDetailsBody({
    super.key,
    required this.state,
    required this.batchId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state is ProductionLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state is ProductionError) {
      return Scaffold(
        body: Center(child: Text((state as ProductionError).message)),
      );
    }

    if (state is! ProductionBatchLoaded) {
      return const SizedBox();
    }

    final batch = (state as ProductionBatchLoaded).batch;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: buildAppBar(
        context,
        title: "Batch Details",
        backgroundColor: theme.colorScheme.primary,
        titleColor: Colors.white,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BatchHeaderCard(batch: batch),
            const SizedBox(height: 20),

            StatusTimeline(currentStep: _statusStep(batch.status)),
            const SizedBox(height: 24),

            ProductionInfoSection(batch: batch),
            const SizedBox(height: 24),

            TimeTrackingSection(batch: batch),
            const SizedBox(height: 24),

            ImagesSection(images: batch.images),
            const SizedBox(height: 32),

            BatchActions(batch: batch, batchId: batchId),
          ],
        ),
      ),
    );
  }

  /// Converts status string → step index
  int _statusStep(String status) {
    switch (status) {
      case "in_progress":
        return 1;
      case "waiting_qc":
        return 2;
      case "passed":
      case "failed":
        return 3;
      default:
        return 0;
    }
  }
}
