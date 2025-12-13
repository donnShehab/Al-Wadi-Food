import 'package:alwadi_food/presentation/animations/staggered_fade_slide_item.dart';
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.batches.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: theme.colorScheme.primary.withOpacity(0.4),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No batches found',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Create a new production batch to see it listed here.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: const Color(0xFFF7F9FC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ------- Header (العنوان + عدد الدُفعات) -------
          Padding(
            padding: AppSpacing.paddingLg.copyWith(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Production',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.batches.length} active batch${widget.batches.length > 1 ? 'es' : ''}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          /// ------- List of Batches -------
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
                  // controller: _controller,
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
