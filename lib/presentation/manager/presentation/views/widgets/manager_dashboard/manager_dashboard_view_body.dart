import 'package:flutter/material.dart';
import 'manager_dashboard_view_body_bloc_consumer.dart';

class ManagerDashboardViewBody extends StatelessWidget {
  const ManagerDashboardViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ManagerDashboardViewBodyBlocConsumer(theme: Theme.of(context));
  }
}
