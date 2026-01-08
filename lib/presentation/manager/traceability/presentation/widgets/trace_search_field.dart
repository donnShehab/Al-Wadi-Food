import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class TraceSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSearch;

  const TraceSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outline.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: scheme.onSurface.withOpacity(0.6)),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: (_) => onSearch(),
              decoration: InputDecoration(
                hintText: "Search by Batch ID, Product, or Line",
                border: InputBorder.none,
                isDense: true,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilledButton.icon(
            onPressed: onSearch,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text("Search"),
          ),
        ],
      ),
    );
  }
}
