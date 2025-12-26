import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_trend_dashboard/qc_trend_chart.dart';
import 'package:flutter/material.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_trend_day_entity.dart';

class QCAnalyticsTrendCard extends StatelessWidget {
  final List<QCTrendDayEntity> trend;

  const QCAnalyticsTrendCard({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: QCTrendChart(trend: trend),
    );
  }
}
