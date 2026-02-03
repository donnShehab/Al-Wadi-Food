import 'dart:ui';

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
        backgroundColor: Colors.transparent,

        // Premium executive top bar: keep logic/actions intact.
        appBar: AppBar(
          title: const Text(
            "Action Center",
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.2),
          ),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.black,
          flexibleSpace: _ExecutiveAppBarSurface(),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () =>
                    context.read<ManagerActionNeededCubit>().loadActionNeeded(),
                tooltip: "Refresh",
              ),
            ),
          ],
        ),

        body: DecoratedBox(
          // MUST remain consistent across the app.
          decoration: _executiveBackgroundDecoration(Theme.of(context)),
          child: SafeArea(
            child:
                BlocBuilder<ManagerActionNeededCubit, ManagerActionNeededState>(
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
                        // Executive Insights Header
                        _InsightsHeader(state: state),

                        const SizedBox(height: 10),

                        // Filter chips (horizontal, premium)
                        ActionCenterFilterChips(
                          selected: _selected,
                          onChanged: (f) => setState(() => _selected = f),
                          pendingCount: state.pendingCount,
                          failedCount: state.failedCount,
                          approvedCount: state.approvedCount,
                          highRiskCount: state.highRiskAlerts.length,
                          archivedCount: state.archivedCount,
                        ),

                        const SizedBox(height: 10),

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
        ),
      ),
    );
  }
}

class _ExecutiveAppBarSurface extends StatelessWidget {
  const _ExecutiveAppBarSurface();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(decoration: _executiveBackgroundDecoration(t)),
        ),
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.72),
                  border: Border(
                    bottom: BorderSide(color: Colors.black.withOpacity(0.05)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InsightsHeader extends StatelessWidget {
  final ManagerActionNeededLoaded state;
  const _InsightsHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

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
    double saved = 0;
    for (final b in state.blockedBatches) {
      final qty = (b["quantity"] ?? 0);
      final unitPrice = (b["unitPrice"] ?? 0); // optional
      if (qty is num && unitPrice is num) saved += qty * unitPrice;
    }

    final failed = state.failedCount;
    final highRisk = state.highRiskAlerts.length;
    final blocked = state.archivedCount;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: t.colorScheme.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.insights_rounded,
                  size: 18,
                  color: t.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Executive Insights",
                      style: t.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Quick snapshot of what needs attention",
                      style: t.textTheme.bodySmall?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              _kpi(t, "Failed", failed.toString(), const Color(0xFFDC143C)),
              const SizedBox(width: 10),
              _kpi(
                t,
                "High Risk",
                highRisk.toString(),
                const Color(0xFFF4B400),
              ),
              const SizedBox(width: 10),
              _kpi(t, "Blocked", blocked.toString(), const Color(0xFF607D8B)),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            "Risk Heatmap (Top Lines)",
            style: t.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          if (top.isEmpty)
            Text(
              "No risk hotspots yet",
              style: t.textTheme.bodySmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: top.map((e) {
                final intensity =
                    (e.value / (top.first.value == 0 ? 1 : top.first.value))
                        .clamp(0.1, 1.0);
                final base = const Color(0xFFF4B400);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: base.withOpacity(0.10 + 0.22 * intensity),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: base.withOpacity(0.18)),
                  ),
                  child: Text(
                    "${e.key} • ${e.value}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      letterSpacing: -0.1,
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 14),

          Text(
            "Financial Guard",
            style: t.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            saved > 0
                ? "Estimated saved revenue: ${saved.toStringAsFixed(2)}"
                : "Add unitPrice to batches to enable revenue estimates",
            style: t.textTheme.bodySmall?.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpi(ThemeData t, String label, String value, Color c) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: c.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: c.withOpacity(0.16)),
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
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: t.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                height: 1.0,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _executiveBackgroundDecoration(ThemeData theme) {
  return BoxDecoration(
    gradient: RadialGradient(
      center: Alignment.topCenter,
      radius: 1.25,
      colors: [
        theme.colorScheme.surface,
        theme.colorScheme.primary.withOpacity(0.035),
      ],
    ),
  );
}
