import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_analytics/qc_analytics_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';

class QCAnalyticsView extends StatelessWidget {
  const QCAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F9FC),
      body: QCAnalyticsViewBodyBlocConsumer(),
    );
  }
}
