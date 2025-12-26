// import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
// import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_dashboard_body_bloc_consumer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';


// class QCDashboardView extends StatelessWidget {
//   const QCDashboardView({super.key});

//   @override
//   Widget build(BuildContext context) {
//         context.read<QCCubit>().loadQCDashboard(); // ✅ مهم
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F9FC),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: theme.colorScheme.primary,
//         title: const Text(
//           "QC Command Center",
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: const QCDashboardBodyConsumer(),
//     );
//   }
// }
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_dashboard_body_bloc_consumer.dart';
import 'package:flutter/material.dart';

class QCDashboardView extends StatelessWidget {
  const QCDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.colorScheme.primary,
          title: const Text(
            "QC Command Center",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,

          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: "Overview", icon: Icon(Icons.dashboard)),
              Tab(text: "Analytics", icon: Icon(Icons.show_chart)),
              Tab(text: "Insights", icon: Icon(Icons.lightbulb)),
              Tab(text: "Reports", icon: Icon(Icons.picture_as_pdf)),
              Tab(text: "Performance", icon: Icon(Icons.leaderboard)),
            ],
          ),
        ),

        body: const QCDashboardBodyConsumer(),
      ),
    );
  }
}
