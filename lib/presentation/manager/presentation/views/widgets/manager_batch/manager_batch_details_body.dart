import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_history/manager_batch_qc_history_cubit.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_batch/manager_batch_header_card.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_batch/manager_batch_images_section.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_batch/manager_batch_production_info_section.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_batch/manager_batch_status_timeline.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_batch/manager_qc_history_section.dart';
import 'package:alwadi_food/presentation/production/cubit/production_state.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:alwadi_food/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ManagerBatchDetailsBody extends StatelessWidget {
  final ProductionState state;
  final String batchId;

  const ManagerBatchDetailsBody({
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
      final error = state as ProductionError;
      return Scaffold(body: Center(child: Text(error.message)));
    }


    if (state is! ProductionBatchLoaded) {
      return const Scaffold(body: SizedBox());
    }

final batch = (state as ProductionBatchLoaded).batch;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: buildAppBar(
        context,
        title: "Batch Overview",
        backgroundColor: Colors.white,
        titleColor: Colors.black87,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            /// ✅ Header Summary (Manager Style)
            ManagerBatchHeaderCard(batch: batch),
            const SizedBox(height: 18),

            /// ✅ Status Timeline
            ManagerBatchStatusTimeline(currentStep: _statusStep(batch.status)),
            const SizedBox(height: 22),

            /// ✅ Production Info
            ManagerBatchProductionInfoSection(batch: batch),
            const SizedBox(height: 22),

            /// ✅ Images
            ManagerBatchImagesSection(images: batch.images),
            const SizedBox(height: 24),

            /// ✅ QC History (MOST IMPORTANT)
BlocProvider(
              create: (_) => getIt<ManagerBatchQcHistoryCubit>()..load(batchId),
              child: ManagerQcHistorySection(batchId: batchId),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

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
