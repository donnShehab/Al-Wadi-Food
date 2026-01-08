import 'package:alwadi_food/presentation/manager/cubit/trace/traceability_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'traceability_search_tab.dart';
import 'traceability_timeline_tab.dart';
import 'traceability_dashboard_tab.dart';
import 'traceability_widgets.dart';

class TraceabilityCenterViewBody extends StatelessWidget {
  const TraceabilityCenterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // ✅ HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
            decoration: BoxDecoration(
              color: scheme.surface,
              border: Border(
                bottom: BorderSide(color: scheme.outline.withOpacity(0.10)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Traceability Center",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                    _actionsMenu(context),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "Track and investigate any batch across production lifecycle.",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withOpacity(0.65),
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    TraceBadge(
                      label: "LIVE",
                      icon: Icons.circle,
                      color: Colors.green,
                      filled: true,
                    ),
                    const SizedBox(width: 10),
                    TraceBadge(
                      label: "FACTORY",
                      icon: Icons.factory_rounded,
                      color: scheme.primary,
                    ),
                    const Spacer(),
                    Text(
                      "Updated now",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface.withOpacity(0.55),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ✅ Operational KPI row (dynamic later)
                const TraceMiniKpiRow(),

                const SizedBox(height: 14),

                // ✅ TAB BAR
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: scheme.outline.withOpacity(0.10)),
                  ),
                  child: TabBar(
                    labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: scheme.primary,
                    ),
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: scheme.onSurface.withOpacity(0.65),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(text: "Search"),
                      Tab(text: "Timeline"),
                      Tab(text: "Dashboard"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ✅ CONTENT
          Expanded(
            child: TabBarView(
              children: [
                const TraceabilitySearchTab(),
                const TraceabilityTimelineTab(),
                const TraceabilityDashboardTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionsMenu(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      tooltip: "Actions",
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: scheme.primary.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.primary.withOpacity(0.18)),
        ),
        child: Icon(Icons.more_vert_rounded, color: scheme.primary),
      ),
      onSelected: (value) async {
        if (!context.mounted) return;

        if (value == "refresh") {
          context.read<TraceabilityCubit>().search();
        }

        if (value == "clear") {
          context.read<TraceabilityCubit>().clearSelected();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Cleared selected batch")),
          );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "refresh",
          child: Row(
            children: [
              Icon(Icons.refresh_rounded, color: scheme.primary),
              const SizedBox(width: 10),
              Text(
                "Refresh",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: "clear",
          child: Row(
            children: [
              Icon(Icons.clear_all_rounded, color: scheme.onSurface),
              const SizedBox(width: 10),
              Text(
                "Clear Selected Batch",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
