import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_today_result_chart.dart';
import 'package:flutter/material.dart';

class QCChartSection extends StatelessWidget {
  final int passedToday;
  final int failedToday;

  const QCChartSection({
    super.key,
    required this.passedToday,
    required this.failedToday,
  });

  @override
  Widget build(BuildContext context) {
    return QCTodayResultChart(passed: passedToday, failed: failedToday);
  }
}

