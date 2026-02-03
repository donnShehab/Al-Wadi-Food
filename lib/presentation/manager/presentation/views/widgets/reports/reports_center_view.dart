import 'dart:ui';

import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/cubit/reports/reports_center_cubit.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/reports/reports_center_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportsCenterView extends StatelessWidget {
  const ReportsCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => getIt<ReportsCenterCubit>()..loadSummary(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0,
          centerTitle: false,
          title: Text(
            "Reports Center",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: Colors.black87,
            ),
          ),
          flexibleSpace: _ExecutiveAppBarSurface(theme: theme),
        ),
        body: DecoratedBox(
          // MUST remain consistent across the app.
          decoration: _executiveBackgroundDecoration(theme),
          child: const SafeArea(child: ReportsCenterViewBody()),
        ),
      ),
    );
  }
}

class _ExecutiveAppBarSurface extends StatelessWidget {
  final ThemeData theme;
  const _ExecutiveAppBarSurface({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: _executiveBackgroundDecoration(theme),
          ),
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
