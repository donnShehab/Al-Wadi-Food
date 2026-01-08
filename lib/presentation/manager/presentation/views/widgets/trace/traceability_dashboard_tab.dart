import 'package:flutter/material.dart';
import 'traceability_widgets.dart';

class TraceabilityDashboardTab extends StatelessWidget {
  const TraceabilityDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        TraceSection(
          title: "Operational Overview",
          subtitle:
              "Track system health, stuck batches and trace completeness (phase 2).",
          child: TraceDashboardKpis(),
        ),
        SizedBox(height: 18),
        TraceSection(
          title: "Stuck Batches (Coming Soon)",
          subtitle: "Batches waiting QC / approval for too long.",
          child: TraceComingSoonCard(),
        ),
        SizedBox(height: 18),
        TraceSection(
          title: "Missing Events Detector (Coming Soon)",
          subtitle: "Detect batches with missing trace events.",
          child: TraceComingSoonCard(),
        ),
      ],
    );
  }
}
