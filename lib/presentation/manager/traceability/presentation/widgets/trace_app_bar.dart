import 'package:alwadi_food/theme.dart';
import 'package:flutter/material.dart';

class TraceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const TraceAppBar({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge?.bold),
      centerTitle: false,
      backgroundColor: scheme.surface,
      elevation: 0,
      leading: onBack == null
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onBack,
            ),
    );
  }
}
