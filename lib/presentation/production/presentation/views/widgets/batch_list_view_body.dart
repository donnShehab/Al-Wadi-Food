import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/animations/staggered_fade_slide_item.dart';
import 'package:alwadi_food/presentation/production/presentation/views/empty_state_view.dart';
import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';
import 'batch_list/batch_list_item.dart';

class BatchListViewBody extends StatefulWidget {
  final List batches;
  const BatchListViewBody({super.key, required this.batches});

  @override
  State<BatchListViewBody> createState() => _BatchListViewBodyState();
}

class _BatchListViewBodyState extends State<BatchListViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _countStatus(String status) {
    return widget.batches.where((b) => b.status == status).length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.batches.isEmpty) {
      return const EmptyStateView(
        icon: Icons.inventory_2_outlined,
        title: 'No batches yet',
        subtitle: 'Start by creating a new production batch',
      );
    }

    final total = widget.batches.length;
    final passed = _countStatus(AppConstants.statusPassed);
    final failed = _countStatus(AppConstants.statusFailed);
    final waiting = _countStatus(AppConstants.statusWaitingQC);
    final inProgress = _countStatus(AppConstants.statusInProgress);

    return DecoratedBox(
      // ✅ UI-only: executive background like Login/Home
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.25,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.primary.withOpacity(0.035),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====== ERP Header ======
          Padding(
            padding: AppSpacing.paddingLg.copyWith(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Production",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                    color: theme.colorScheme.onSurface.withOpacity(0.92),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$total active batch${total > 1 ? 'es' : ''}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.78),
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 14),

                // ====== Summary Chips (UI only, not filtering) ======
                Row(
                  children: [
                    Expanded(
                      child: _SummaryChip(
                        label: 'In Progress',
                        value: inProgress,
                        tone: _ChipTone.blue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SummaryChip(
                        label: 'Waiting QC',
                        value: waiting,
                        tone: _ChipTone.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryChip(
                        label: 'Passed',
                        value: passed,
                        tone: _ChipTone.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SummaryChip(
                        label: 'Failed',
                        value: failed,
                        tone: _ChipTone.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ====== List ======
          Expanded(
            child: ListView.separated(
              padding: AppSpacing.paddingMd,
              itemCount: widget.batches.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final batch = widget.batches[index];
                return StaggeredSlideFade(
                  index: index,
                  delay: Duration(milliseconds: 80 * index),
                  offsetY: 30,
                  child: BatchListItem(batch: batch),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum _ChipTone { blue, orange, green, red }

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final int value;
  final _ChipTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color base;
    switch (tone) {
      case _ChipTone.blue:
        base = Colors.blue;
        break;
      case _ChipTone.orange:
        base = Colors.orange;
        break;
      case _ChipTone.green:
        base = Colors.green;
        break;
      case _ChipTone.red:
        base = Colors.red;
        break;
    }

    final surface = theme.colorScheme.surface;
    final border = theme.colorScheme.onSurface.withOpacity(0.08);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: base.withOpacity(0.85),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface.withOpacity(0.9),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$value',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: base.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
