import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_pending_list_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/di/injection.dart';

class QCPendingListView extends StatelessWidget {
  const QCPendingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QCCubit>()..loadPendingBatches(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Pending QC Inspections')),
        body: const QCPendingListBodyBlocConsumer(),
      ),
    );
  }
}
