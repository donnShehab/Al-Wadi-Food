import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/manager/cubit/trace/traceability_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/trace/traceability_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'traceability_widgets.dart';

class TraceabilitySearchTab extends StatefulWidget {
  const TraceabilitySearchTab({super.key});

  @override
  State<TraceabilitySearchTab> createState() => _TraceabilitySearchTabState();
}

class _TraceabilitySearchTabState extends State<TraceabilitySearchTab> {
  final searchCtrl = TextEditingController();

  final statuses = const [
    "All",
    "waiting_qc",
    "passed",
    "failed",
    "in_progress",
  ];

  final lines = const ["All", ...AppConstants.productionLines];

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<TraceabilityCubit, TraceabilityState>(
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TraceSection(
              title: "Trace Search",
              subtitle:
                  "Search batches by Batch ID, status or production line.",
              child: Column(
                children: [
                  _searchField(context),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _dropdown(
                          context,
                          label: "Status",
                          value: state.statusFilter,
                          items: statuses,
                          onChanged: (v) => context
                              .read<TraceabilityCubit>()
                              .updateStatusFilter(v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dropdown(
                          context,
                          label: "Line",
                          value: state.lineFilter,
                          items: lines,
                          onChanged: (v) => context
                              .read<TraceabilityCubit>()
                              .updateLineFilter(v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: scheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: state.status == TraceabilityStatus.searching
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.search_rounded),
                          label: const Text(
                            "Search",
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          onPressed: () =>
                              context.read<TraceabilityCubit>().search(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        tooltip: "Clear",
                        icon: Icon(
                          Icons.clear_rounded,
                          color: scheme.onSurface.withValues(alpha: 0.70),
                        ),
                        onPressed: () {
                          searchCtrl.clear();
                          context.read<TraceabilityCubit>().updateQuery("");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            TraceSection(
              title: "Results",
              subtitle:
                  "Tap any batch to open full trace timeline and QC evidence.",
              child: Column(
                children: [
                  if (state.searchResults.isEmpty)
                    const TraceEmptyState(
                      title: "No results yet",
                      subtitle: "Try searching by batch ID or change filters.",
                      icon: Icons.search_off_rounded,
                    )
                  else
                    ...state.searchResults.map((r) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TraceResultCard(
                          batchId: r.batchId,
                          batchName: r.batchName,
                          productName: r.productName,
                          line: r.lineName,
                          status: r.status,
                          risk: r.risk,
                          onTap: () async {
                            await context
                                .read<TraceabilityCubit>()
                                .openBatchTrace(r.batchId);
                            DefaultTabController.of(context).animateTo(1);
                          },
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _searchField(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextField(
      controller: searchCtrl,
      style: const TextStyle(fontWeight: FontWeight.w800),
      onChanged: (v) => context.read<TraceabilityCubit>().updateQuery(v),
      decoration: InputDecoration(
        hintText: "Search by Batch ID or name (ex: Burger Line Laska)",
        prefixIcon: Icon(Icons.qr_code_scanner_rounded, color: scheme.primary),
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary.withValues(alpha: 0.60)),
        ),
      ),
    );
  }

  Widget _dropdown(
    BuildContext context, {
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.10)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: scheme.primary),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: scheme.onSurface,
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text("$label: $e")))
              .toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }
}
