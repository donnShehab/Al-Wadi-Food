import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/cubit/reports/reports_center_cubit.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/reports/reports_center_view_body.dart';
import 'package:alwadi_food/presentation/settings/cubit/app_settings_cubit.dart';
import 'package:alwadi_food/presentation/settings/cubit/app_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsCenterView extends StatelessWidget {
  const ReportsCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReportsCenterCubit>()..loadSummary(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reports Center"),
         
        ),
        body: const ReportsCenterViewBody(),
      ),
    );
  }
}
