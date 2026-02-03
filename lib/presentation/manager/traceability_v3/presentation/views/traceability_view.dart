import 'dart:ui';

import 'package:alwadi_food/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';

import '../cubit/traceability_cubit.dart';
import '../cubit/traceability_state.dart';
import 'traceability_view_body.dart';
import 'recall_audit_viewer_view.dart';

import '../../domain/repositories/traceability_repository.dart';

class TraceabilityView extends StatefulWidget {
  /// null/empty => picker mode
  /// non-empty  => graph mode
  final String? rootNodeId;

  const TraceabilityView({super.key, this.rootNodeId});

  @override
  State<TraceabilityView> createState() => _TraceabilityViewState();
}

class _TraceabilityViewState extends State<TraceabilityView> {
  late final TraceabilityV3Repository _repository;
  late final TraceabilityCubit _cubit;

  bool _canManageRecalls(String role) {
    // Keep RBAC logic unchanged
    return true;
  }

  String? get _normalizedRoot {
    final v = widget.rootNodeId;
    if (v == null) return null;
    final trimmed = v.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  void initState() {
    super.initState();
    _repository = getIt<TraceabilityV3Repository>();
    _cubit = TraceabilityCubit(_repository);

    final root = _normalizedRoot;
    if (root != null) {
      _cubit.loadGraph(root); // auto-load immediately
    }
  }

  @override
  void didUpdateWidget(covariant TraceabilityView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.rootNodeId != widget.rootNodeId) {
      final root = _normalizedRoot;
      if (root == null) {
        _cubit.reset();
      } else {
        _cubit.loadGraph(root);
      }
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = context.watch<AuthCubit>().state;

    final bool isAuthorized =
        authState is AuthSuccess && _canManageRecalls(authState.user.role);

    return BlocProvider.value(
      value: _cubit,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: theme.colorScheme.surface),
          DecoratedBox(
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
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: _GlassAppBar(
              title: 'Traceability',
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.maybePop(context),
                tooltip: 'Back',
              ),
              actions: [
                if (_normalizedRoot != null)
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Refresh',
                    onPressed: () {
                      final root = _normalizedRoot;
                      if (root != null) {
                        context.read<TraceabilityCubit>().loadGraph(root);
                      }
                    },
                  ),
                if (isAuthorized)
                  IconButton(
                    icon: const Icon(Icons.history_rounded),
                    tooltip: 'Recall Audit History',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RecallAuditViewerView(repository: _repository),
                        ),
                      );
                    },
                  ),
              ],
            ),
            body: SafeArea(
              top: true,
              child: _normalizedRoot == null
                  ? const _TraceabilityEmptyPicker()
                  : BlocConsumer<TraceabilityCubit, TraceabilityState>(
                      listener: (context, state) {
                        if (state is TraceabilityRecallExecuted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Recall executed successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }

                        if (state is TraceabilityError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is TraceabilityInitial ||
                            state is TraceabilityLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return TraceabilityViewBody(
                          state: state,
                          rootNodeId: _normalizedRoot!,
                          onConfirmRecall: (recallResult) {
                            final auth = context.read<AuthCubit>().state;
                            if (auth is! AuthSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('You must be logged in'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            final user = auth.user;

                            if (!_canManageRecalls(user.role)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'You are not authorized to execute recalls',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            context.read<TraceabilityCubit>().executeRecall(
                              recallResult: recallResult,
                              managerId: user.uid,
                              managerName: user.name,
                            );
                          },
                        );
                      },
                    ),
            ),
            //
          ),
        ],
      ),
    );
  }
}

class _TraceabilityEmptyPicker extends StatelessWidget {
  const _TraceabilityEmptyPicker();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white.withOpacity(0.75),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.primary.withOpacity(0.14)),
              ),
              child: Icon(
                Icons.alt_route_rounded,
                color: scheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Load a batch to view traceability',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Open a batch from Action Center, Reports, or scan a batch ID to start.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Executive glass app bar (UI-only).
class _GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget> actions;

  const _GlassAppBar({
    required this.title,
    this.leading,
    this.actions = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      centerTitle: true,
      leading: leading,
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: scheme.onSurface,
      actions: actions,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: scheme.surface.withOpacity(0.70),
              border: Border(
                bottom: BorderSide(color: scheme.outline.withOpacity(0.10)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
