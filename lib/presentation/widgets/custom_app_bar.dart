import 'package:flutter/material.dart';

AppBar buildAppBar(
  BuildContext context, {
  required String title,
  Color? backgroundColor,
  Color? titleColor,
  bool showBackButton = true,
  Icon? iconBackButton,
  List<Widget>? actions,
}) {
  final theme = Theme.of(context);

  // استخدم لون الخلفية من colorScheme إذا لم يتم تحديده
  final bgColor = backgroundColor ?? theme.colorScheme.primary;
  // استخدم لون النص من colorScheme إذا لم يتم تحديده
  final fgColor = titleColor ?? theme.colorScheme.onPrimary;

  return AppBar(
    backgroundColor: bgColor,
    elevation: 0,
    centerTitle: true,
    title: Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: fgColor,
      ),
    ),
    leading: showBackButton
        ? IconButton(
            icon: iconBackButton ?? Icon(Icons.arrow_back, color: fgColor),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        : null,
    actions: actions,
  );
}