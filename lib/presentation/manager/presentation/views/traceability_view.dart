import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/cubit/traceability_cubit.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/traceability_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TraceabilityView extends StatelessWidget {
  const TraceabilityView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TraceabilityCubit>(),
      child:  Scaffold(
        appBar: AppBar(title: Text("Traceability Reports")),
        body: TraceabilityViewBody(),
      ),
    );
  }
}
