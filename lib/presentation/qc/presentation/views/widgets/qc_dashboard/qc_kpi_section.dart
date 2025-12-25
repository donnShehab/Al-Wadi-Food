import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_stat_card.dart';
import 'package:flutter/material.dart';

class QCKPISection extends StatelessWidget {
  final int pendingCount;
  final int passedToday;
  final int failedToday;

  const QCKPISection({
    super.key,
    required this.pendingCount,
    required this.passedToday,
    required this.failedToday,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: Row(
        
        children: [
          QCStatCard(
            title: "Pending",
            value: pendingCount,
            icon: Icons.hourglass_bottom,
            iconColor: Colors.orange,
          ),
          const SizedBox(width: 12),
          QCStatCard(
            title: "Passed",
            value: passedToday,
            icon: Icons.check_circle,
            iconColor: Colors.green,
          ),
          const SizedBox(width: 12),
          QCStatCard(
            title: "Failed",
            value: failedToday,
            icon: Icons.cancel,
            iconColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
