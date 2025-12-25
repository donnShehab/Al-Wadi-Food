import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_dashboard_body_bloc_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class QCDashboardView extends StatelessWidget {
  const QCDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
        context.read<QCCubit>().loadQCDashboard(); // ✅ مهم
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.primary,
        title: const Text(
          "QC Command Center",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: const QCDashboardBodyConsumer(),
    );
  }
}
