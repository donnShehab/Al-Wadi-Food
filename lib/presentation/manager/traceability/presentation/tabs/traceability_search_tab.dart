import 'package:alwadi_food/presentation/manager/traceability/cubit/traceability_cubit.dart';
import 'package:alwadi_food/presentation/manager/traceability/cubit/traceability_state.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_empty_state.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_loading_state.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_result_card.dart';
import 'package:alwadi_food/presentation/manager/traceability/presentation/widgets/trace_search_field.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TraceabilitySearchTab extends StatefulWidget {
  const TraceabilitySearchTab({super.key});

  @override
  State<TraceabilitySearchTab> createState() => _TraceabilitySearchTabState();
}

class _TraceabilitySearchTabState extends State<TraceabilitySearchTab> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: AppSpacing.paddingMd,
      child: Column(
        children: [
          TraceSearchField(
            controller: _controller,
            onChanged: (v) => context.read<TraceabilityCubit>().updateQuery(v),
            onSearch: () => context.read<TraceabilityCubit>().search(),
          ),
          const SizedBox(height: AppSpacing.md),

          _FiltersRow(
            onApply: () => context.read<TraceabilityCubit>().search(),
          ),
          const SizedBox(height: AppSpacing.md),

          Expanded(
            child: BlocBuilder<TraceabilityCubit, TraceabilityState>(
              builder: (context, state) {
                if (state.status == TraceabilityViewStatus.searching) {
                  return const TraceLoadingState(
                    title: "Searching batches...",
                    subtitle: "Filtering by your query and recent batches.",
                  );
                }

                if (state.status == TraceabilityViewStatus.error) {
                  return TraceEmptyState(
                    icon: Icons.error_rounded,
                    title: "Search failed",
                    subtitle: state.error ?? "Unknown error",
                    action: OutlinedButton.icon(
                      onPressed: () =>
                          context.read<TraceabilityCubit>().search(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text("Retry"),
                    ),
                  );
                }

                if (state.results.isEmpty) {
                  return TraceEmptyState(
                    icon: Icons.search_off_rounded,
                    title: "No results",
                    subtitle: "Try a different keyword or clear filters.",
                    action: OutlinedButton.icon(
                      onPressed: () {
                        context.read<TraceabilityCubit>().updateQuery('');
                        context.read<TraceabilityCubit>().updateStatusFilter(
                          'All',
                        );
                        context.read<TraceabilityCubit>().updateLineFilter(
                          'All',
                        );
                        context.read<TraceabilityCubit>().search();
                      },
                      icon: const Icon(Icons.clear_all_rounded),
                      label: const Text("Clear filters"),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: state.results.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, i) {
                    final r = state.results[i];

                    return TraceResultCard(
                      batchCode: r.batchCode, // display
                      product: r.product,
                      line: r.line,
                      status: r.status,
                      riskScore: r.riskScore,
                      imageUrl: r.imageUrl,
                      quantity: r.quantity,
                      createdAt: r.createdAt,
                      onTap: () async {
                        await context.read<TraceabilityCubit>().openBatch(
                          r.docId,
                        );
                        DefaultTabController.of(context).animateTo(1);
                      },
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 4),
          Text(
            "Tip: Use Timeline tab to view full history and QC evidence once a batch is selected.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltersRow extends StatelessWidget {
  final VoidCallback onApply;

  const _FiltersRow({required this.onApply});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<TraceabilityCubit, TraceabilityState>(
      builder: (context, state) {
        final cubit = context.read<TraceabilityCubit>();

        Widget drop({
          required String value,
          required List<String> items,
          required ValueChanged<String?> onChanged,
        }) {
          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: scheme.outline.withOpacity(0.25)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  icon: Icon(
                    Icons.expand_more_rounded,
                    color: scheme.onSurface.withOpacity(0.7),
                  ),
                  items: items
                      .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                      .toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          );
        }

        return Row(
          children: [
            drop(
              value: state.statusFilter,
              items: const [
                "All",
                "in_progress",
                "waiting_qc",
                "passed",
                "failed",
              ],
              onChanged: (v) {
                if (v == null) return;
                cubit.updateStatusFilter(v);
                onApply();
              },
            ),
            const SizedBox(width: AppSpacing.md),
            drop(
              value: state.lineFilter,
              items: const ["All", "Line A", "Line B", "Line C"],
              onChanged: (v) {
                if (v == null) return;
                cubit.updateLineFilter(v);
                onApply();
              },
            ),
          ],
        );
      },
    );
  }
}
