import 'package:flutter/material.dart';
import 'manager_main_view_body_bloc_consumer.dart';

class ManagerMainViewBody extends StatelessWidget {
  const ManagerMainViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ManagerMainViewBodyBlocConsumer(theme: Theme.of(context));
  }
}
