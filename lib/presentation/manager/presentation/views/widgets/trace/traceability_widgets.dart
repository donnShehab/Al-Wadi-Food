import 'package:alwadi_food/presentation/manager/domain/entities/trace_event_entity.dart';
import 'package:alwadi_food/presentation/qc/domain/entites/qc_result_entity.dart';
import 'package:flutter/material.dart';

// ============================================================
// ✅ Trace Section Container
// ============================================================
class TraceSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const TraceSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: scheme.surface,
        border: Border.all(color: scheme.outline.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.layers_rounded, color: scheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ============================================================
// ✅ Badge Widget
// ============================================================
class TraceBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool filled;

  const TraceBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: filled ? color.withValues(alpha: 0.12) : Colors.transparent,
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 11,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class TraceEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const TraceEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: scheme.surfaceContainerHighest.withOpacity(0.20),
        border: Border.all(color: scheme.outline.withOpacity(0.10)),
      ),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                    color: scheme.onSurface.withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ✅ KPI Row (Realistic Placeholder until connected)
// ============================================================
class TraceMiniKpiRow extends StatelessWidget {
  const TraceMiniKpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget item(String label, String value, Color color) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface.withOpacity(0.60),
              ),
            ),
          ],
        ),
      );
    }

    Widget divider() {
      return Container(
        width: 1,
        height: 28,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: scheme.outline.withOpacity(0.12),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: scheme.surface,
        border: Border.all(color: scheme.outline.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          item("Tracked", "-", scheme.primary),
          divider(),
          item("Pending QC", "-", Colors.orange),
          divider(),
          item("Pending Approval", "-", scheme.primary),
          divider(),
          item("High Risk", "-", Colors.redAccent),
        ],
      ),
    );
  }
}

// ============================================================
// ✅ Result Card UI (Batch + Product + Status + Risk)
// ============================================================
class TraceResultCard extends StatelessWidget {
  final String batchId;
  final String batchName;
  final String productName;
  final String line;
  final String status;
  final int risk;
  final VoidCallback onTap;

  const TraceResultCard({
    super.key,
    required this.batchId,
    required this.batchName,
    required this.productName,
    required this.line,
    required this.status,
    required this.risk,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final color = status.toLowerCase().contains("passed")
        ? Colors.green
        : status.toLowerCase().contains("failed")
        ? Colors.redAccent
        : status.toLowerCase().contains("waiting")
        ? scheme.primary
        : Colors.orange;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.20),
          border: Border.all(color: color.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: color.withValues(alpha: 0.12),
              ),
              child: Icon(Icons.qr_code_rounded, color: color),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    batchId,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    batchName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Line: $line • Risk: $risk",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),

            TraceBadge(
              label: status.toUpperCase(),
              icon: Icons.circle,
              color: color,
              filled: true,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ✅ Timeline Live Card (From Firestore Events)
// ============================================================
class TraceTimelineLiveCard extends StatelessWidget {
  final String batchId;
  final String line;
  final String product;
  final List<TraceEventEntity> events;

  const TraceTimelineLiveCard({
    super.key,
    required this.batchId,
    required this.line,
    required this.product,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (events.isEmpty) {
      return const TraceEmptyState(
        title: "No timeline events yet",
        subtitle: "This batch has missing trace events.",
        icon: Icons.warning_amber_rounded,
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.12)),
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_rounded, color: scheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      batchId,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$product • $line",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          Divider(color: scheme.outline.withValues(alpha: 0.12)),
          const SizedBox(height: 14),

          ...events.map((e) => _eventTile(context, e)).toList(),
        ],
      ),
    );
  }

  Widget _eventTile(BuildContext context, TraceEventEntity e) {
    final scheme = Theme.of(context).colorScheme;
    final title = TraceEventTypeMapper.toTitle(e.type);
    final icon = TraceEventTypeMapper.toIcon(e.type);
    final color = TraceEventTypeMapper.toColor(e.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  e.note ?? "No note provided",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatDate(e.timestamp),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return "${dt.day}/${dt.month} ${dt.hour}:${dt.minute.toString().padLeft(2, "0")}";
  }
}

// ============================================================
// ✅ QC Results Card (Evidence)
// ============================================================
class TraceQcResultsCard extends StatelessWidget {
  final List<QCResultEntity> results;

  const TraceQcResultsCard({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (results.isEmpty) {
      return const TraceEmptyState(
        title: "No QC inspections",
        subtitle: "No inspections found for this batch.",
        icon: Icons.assignment_late_rounded,
      );
    }

    return Column(
      children: results.map((r) {
        final isPass = r.result.toLowerCase().contains("pass");
        final color = isPass ? Colors.green : Colors.redAccent;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: scheme.surfaceContainerHighest.withValues(alpha: 0.20),
            border: Border.all(color: color.withValues(alpha: 0.20)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: color.withValues(alpha: 0.10),
                ),
                child: Icon(Icons.assignment_turned_in_rounded, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Inspection: ${r.inspectionId}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Result: ${r.result.toUpperCase()}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              TraceBadge(
                label: r.result.toUpperCase(),
                icon: Icons.circle,
                color: color,
                filled: true,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================
// ✅ Dashboard KPIs Placeholder
// ============================================================
class TraceDashboardKpis extends StatelessWidget {
  const TraceDashboardKpis({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget kpi(String title, String value, IconData icon, Color color) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: scheme.surface,
            border: Border.all(color: color.withOpacity(0.18)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: color.withOpacity(0.10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            kpi("Stuck > 2h", "-", Icons.timer_rounded, Colors.orange),
            const SizedBox(width: 12),
            kpi("Missing Events", "-", Icons.warning_rounded, Colors.redAccent),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            kpi(
              "Pending Approval",
              "-",
              Icons.verified_rounded,
              scheme.primary,
            ),
            const SizedBox(width: 12),
            kpi(
              "Resolved Risks",
              "-",
              Icons.check_circle_rounded,
              Colors.green,
            ),
          ],
        ),
      ],
    );
  }
}

class TraceComingSoonCard extends StatelessWidget {
  const TraceComingSoonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: scheme.surfaceContainerHighest.withOpacity(0.25),
        border: Border.all(color: scheme.outline.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.construction_rounded, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Coming soon: will connect analytics, stuck batches, and missing events detector.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// ✅ Mapper for event types
// ============================================================
class TraceEventTypeMapper {
  static String toTitle(String type) {
    switch (type) {
      case "CREATED":
        return "Batch Created";
      case "SENT_TO_QC":
        return "Sent To QC";
      case "QC_PASSED":
        return "QC Passed";
      case "QC_FAILED":
        return "QC Failed";
      case "APPROVED":
        return "Approved";
      case "REJECTED":
        return "Rejected";
      case "RISK_DETECTED":
        return "Risk Detected";
      case "RISK_RESOLVED":
        return "Risk Resolved";
      default:
        return "Event";
    }
  }

  static IconData toIcon(String type) {
    switch (type) {
      case "CREATED":
        return Icons.factory_rounded;
      case "SENT_TO_QC":
        return Icons.send_rounded;
      case "QC_PASSED":
        return Icons.check_circle_rounded;
      case "QC_FAILED":
        return Icons.cancel_rounded;
      case "APPROVED":
        return Icons.verified_rounded;
      case "REJECTED":
        return Icons.block_rounded;
      case "RISK_DETECTED":
        return Icons.warning_amber_rounded;
      case "RISK_RESOLVED":
        return Icons.shield_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  static Color toColor(String type) {
    switch (type) {
      case "QC_PASSED":
      case "APPROVED":
      case "RISK_RESOLVED":
        return Colors.green;
      case "QC_FAILED":
      case "REJECTED":
        return Colors.redAccent;
      case "RISK_DETECTED":
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }
}
