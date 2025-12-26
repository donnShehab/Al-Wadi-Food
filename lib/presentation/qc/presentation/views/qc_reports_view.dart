import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_reports/qc_reports_cubit.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_reports/qc_reports_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class QCReportsView extends StatelessWidget {
  const QCReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QCReportsCubit>(),
      child: const QCReportsViewBody(),
    );
  }
}
