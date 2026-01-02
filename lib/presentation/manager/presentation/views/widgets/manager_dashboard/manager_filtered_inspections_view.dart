import 'package:alwadi_food/presentation/manager/cubit/manager_dashboard/manager_filtered_inspections_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manager_filtered_inspections_view_body.dart';
import 'package:alwadi_food/core/di/injection.dart';

class ManagerFilteredInspectionsView extends StatelessWidget {
  final String title;
  final String filterType;
  final String filterValue;

  const ManagerFilteredInspectionsView({
    super.key,
    required this.title,
    required this.filterType,
    required this.filterValue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ManagerFilteredInspectionsCubit>()
            ..loadFiltered(filterType: filterType, filterValue: filterValue),
      child: ManagerFilteredInspectionsViewBody(
        title: title,
        filterType: filterType,
        filterValue: filterValue,
      ),
    );
  }
}
