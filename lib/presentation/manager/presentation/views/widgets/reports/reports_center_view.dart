import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/cubit/reports/reports_center_cubit.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/reports/reports_center_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsCenterView extends StatelessWidget {
  const ReportsCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (_) => getIt<ReportsCenterCubit>()..loadSummary(),
      child: Scaffold(
        backgroundColor: scheme.surface,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: scheme.surface,
          titleSpacing: 0,
          centerTitle: false,
          title: Text(
            "Reports Center",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          shape: Border(
            bottom: BorderSide(color: scheme.outline.withOpacity(0.10)),
          ),
        ),
        body: const ReportsCenterViewBody(),
      ),
    );
  }
}
