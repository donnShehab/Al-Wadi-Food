import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'action_center_filter_chips.dart';
import 'manager_action_needed_view_body.dart';

class ManagerActionNeededView extends StatefulWidget {
  const ManagerActionNeededView({super.key});

  @override
  State<ManagerActionNeededView> createState() =>
      _ManagerActionNeededViewState();
}

class _ManagerActionNeededViewState extends State<ManagerActionNeededView> {
  ActionCenterFilter _selected = ActionCenterFilter.failed;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ManagerActionNeededCubit>()..loadActionNeeded(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text(
            "Action Center",
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () =>
                    context.read<ManagerActionNeededCubit>().loadActionNeeded(),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ManagerActionNeededCubit, ManagerActionNeededState>(
          builder: (context, state) {
            if (state is ManagerActionNeededLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ManagerActionNeededError) {
              return Center(child: Text(state.message));
            }
            if (state is! ManagerActionNeededLoaded) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                // ✅ Premium Insights Header (executive)
                _InsightsHeader(state: state),

                const SizedBox(height: 8),

                // ✅ Horizontal scroll filter chips (no overflow)
                ActionCenterFilterChips(
                  selected: _selected,
                  onChanged: (f) => setState(() => _selected = f),
                  pendingCount: state.pendingCount,
                  failedCount: state.failedCount,
                  approvedCount: state.approvedCount,
                  highRiskCount: state.highRiskAlerts.length,
                  archivedCount: state.archivedCount,
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: ManagerActionNeededViewBody(
                      key: ValueKey(_selected),
                      selectedFilter: _selected,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InsightsHeader extends StatelessWidget {
  final ManagerActionNeededLoaded state;
  const _InsightsHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    // --- Heatmap: failures per line (top 5)
    final Map<String, int> failuresByLine = {};
    for (final x in [...state.failedInspections, ...state.highRiskAlerts]) {
      final line = (x["line"] ?? x["productionLine"] ?? "Unknown").toString();
      failuresByLine[line] = (failuresByLine[line] ?? 0) + 1;
    }

    final sorted = failuresByLine.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = sorted.take(5).toList();

    // --- Saved revenue estimate from blocked batches (simple heuristic)
    // If you have unitPrice, replace this with real calculation.
    double saved = 0;
    for (final b in state.blockedBatches) {
      final qty = (b["quantity"] ?? 0);
      final unitPrice = (b["unitPrice"] ?? 0); // optional
      if (qty is num && unitPrice is num) saved += qty * unitPrice;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Executive Insights",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              _kpi("Failed", state.failedCount.toString(), Colors.red),
              const SizedBox(width: 10),
              _kpi(
                "High Risk",
                state.highRiskAlerts.length.toString(),
                Colors.orange,
              ),
              const SizedBox(width: 10),
              _kpi("Blocked", state.archivedCount.toString(), Colors.blueGrey),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            "Risk Heatmap (Top Lines)",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),

          if (top.isEmpty)
            Text(
              "No risk hotspots yet",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: top.map((e) {
                final intensity =
                    (e.value / (top.first.value == 0 ? 1 : top.first.value))
                        .clamp(0.1, 1.0);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.10 + 0.25 * intensity),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.20)),
                  ),
                  child: Text(
                    "${e.key} • ${e.value}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 12),
          Text(
            "Financial Guard",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            saved > 0
                ? "Estimated saved revenue: ${saved.toStringAsFixed(2)}"
                : "Add unitPrice to batches to enable revenue estimates",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _kpi(String label, String value, Color c) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: c.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.withOpacity(0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: c,
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
