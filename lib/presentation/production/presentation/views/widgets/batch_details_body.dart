import 'dart:ui';
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
      appBar: buildAppBar(
        context,
        title: "Batch Details",
        backgroundColor: theme.colorScheme.primary,
        titleColor: Colors.white,
        showBackButton: true,
      ),
      body: DecoratedBox(
        // ✅ Executive background (UI only)
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.3,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primary.withOpacity(0.035),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ===== Header =====
                BatchHeaderCard(batch: batch),

                const SizedBox(height: 22),

                // ===== Status Timeline =====
                _ExecutiveSection(
                  child: StatusTimeline(currentStep: _statusStep(batch.status)),
                ),

                const SizedBox(height: 22),

                // ===== Production Info =====
                _ExecutiveSection(
                  title: "Production Information",
                  child: ProductionInfoSection(batch: batch),
                ),

                const SizedBox(height: 22),

                // ===== Time Tracking =====
                _ExecutiveSection(
                  title: "Time Tracking",
                  child: TimeTrackingSection(batch: batch),
                ),

                const SizedBox(height: 22),

                // ===== Images =====
                _ExecutiveSection(
                  title: "Images",
                  child: ImagesSection(images: batch.images),
                ),

                const SizedBox(height: 32),

                // ===== Actions =====
                BatchActions(batch: batch, batchId: batchId),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Converts status string → step index (UNCHANGED)
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

/// ===========================
///  Executive Section Wrapper
/// ===========================
/// UI-only wrapper to unify cards appearance
class _ExecutiveSection extends StatelessWidget {
  final Widget child;
  final String? title;

  const _ExecutiveSection({required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final border = theme.colorScheme.onSurface.withOpacity(0.08);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.1,
                color: theme.colorScheme.onSurface.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 14),
          ],
          child,
        ],
      ),
    );
  }
}
