import 'package:alwadi_food/presentation/manager/cubit/dashboard_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/dashboard_state.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/dashboard_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DashboardViewBodyBlocConsumer extends StatelessWidget {
  const DashboardViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is DashboardError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DashboardLoaded) {
          return DashboardViewBody(data: state.data);
        }

        if (state is DashboardError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
