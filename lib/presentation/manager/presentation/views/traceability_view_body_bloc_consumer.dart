import 'package:alwadi_food/presentation/manager/cubit/traceability_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/traceability_state.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/Traceability/batch_card.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TraceabilityViewBodyBlocConsumer extends StatelessWidget {
  const TraceabilityViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TraceabilityCubit, TraceabilityState>(
      listener: (context, state) {
        if (state is TraceabilityError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is TraceabilityLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TraceabilityLoaded) {
          return ListView(
            padding: AppSpacing.paddingMd,
            children: [
              BatchCard(batch: state.batch),
              const SizedBox(height: 16),
              ...state.qcResults.map(
                (qc) => ListTile(
                  title: Text("QC Result: ${qc.result}"),
                  subtitle: Text(qc.failureReason ?? "No reason"),
                ),
              ),
            ],
          );
        }

        return const Center(child: Text("Select a batch to view data"));
      },
    );
  }
}
