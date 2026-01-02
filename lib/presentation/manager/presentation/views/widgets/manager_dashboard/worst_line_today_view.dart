import 'package:alwadi_food/presentation/manager/cubit/manager_dashboard/worst_line_today_cubit.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_dashboard/worst_line_today_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/core/di/injection.dart';

class WorstLineTodayView extends StatelessWidget {
  final String lineName;

  const WorstLineTodayView({super.key, required this.lineName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<WorstLineTodayCubit>()
            ..loadWorstLineFailedInspections(lineName),
      child: WorstLineTodayViewBody(lineName: lineName),
    );
  }
}
  