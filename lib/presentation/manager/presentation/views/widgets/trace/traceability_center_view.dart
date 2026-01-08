import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/cubit/trace/traceability_cubit.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/trace/traceability_center_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TraceabilityCenterView extends StatelessWidget {
  const TraceabilityCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TraceabilityCubit>()..search(),
      child: const TraceabilityCenterViewBody(),
    );
  }
}
