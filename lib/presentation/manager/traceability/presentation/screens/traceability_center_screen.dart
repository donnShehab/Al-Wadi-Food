import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/traceability/cubit/traceability_cubit.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/tabs/traceability_dashboard_tab.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/tabs/traceability_search_tab.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/tabs/traceability_timeline_tab.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_app_bar.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TraceabilityCenterScreen extends StatelessWidget {
  /// Optional: open directly to a specific batch (route deep-link).
  final String? initialBatchId;

  /// If true, show back button (standalone route).
  final bool standalone;

  const TraceabilityCenterScreen({
    super.key,
    this.initialBatchId,
    this.standalone = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TraceabilityCubit>()..init(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<TraceabilityCubit>();

          // If deep-link batchId provided, load it after first frame.
          if (initialBatchId != null && initialBatchId!.trim().isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              cubit.openBatch(initialBatchId!.trim());
            });
          }

          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: TraceAppBar(
                title: "Traceability Center",
                onBack: standalone
                    ? () => Navigator.of(context).maybePop()
                    : null,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.25),
                        ),
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: Theme.of(
                          context,
                        ).textTheme.labelLarge?.bold,
                        tabs: const [
                          Tab(icon: Icon(Icons.search_rounded), text: "Search"),
                          Tab(
                            icon: Icon(Icons.timeline_rounded),
                            text: "Timeline",
                          ),
                          Tab(
                            icon: Icon(Icons.analytics_rounded),
                            text: "Dashboard",
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        TraceabilitySearchTab(),
                        TraceabilityTimelineTab(),
                        TraceabilityDashboardTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
