import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_analytics/qc_analytics_view_body_bloc_consumer.dart';
import 'package:flutter/material.dart';

class QCAnalyticsView extends StatelessWidget {
  const QCAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Used inside QCCommandCenterView (which already provides AppBar + bottom nav).
    // Avoid nested Scaffolds/AppBars for a cleaner executive look.
    return const QCAnalyticsViewBodyBlocConsumer();
  }
}
