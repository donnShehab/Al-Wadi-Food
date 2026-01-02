import 'package:alwadi_food/presentation/manager/cubit/manager_dashboard/worst_line_today_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_dashboard/worst_line_today_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_dashboard/manager_insight_inspection_tile.dart';

class WorstLineTodayViewBody extends StatelessWidget {
  final String lineName;

  const WorstLineTodayViewBody({super.key, required this.lineName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text("Worst Line Today - $lineName"),
        centerTitle: true,
      ),
      body: BlocBuilder<WorstLineTodayCubit, WorstLineTodayState>(
        builder: (context, state) {
          if (state is WorstLineTodayLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WorstLineTodayLoaded) {
            if (state.items.isEmpty) {
              return const Center(
                child: Text(
                  "✅ No failed inspections for this line today!",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ManagerInsightInspectionTile(data: item);
              },
            );
          }

          if (state is WorstLineTodayError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
