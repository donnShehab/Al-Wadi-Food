import 'package:flutter/material.dart';

import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_dashboard_body_bloc_builder.dart';

class QCDashboardView extends StatelessWidget {
  const QCDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(title: const Text('QC Dashboard')),
        body: const QCDashboardBodyBlocBuilder(),
      
    );
  }
}
