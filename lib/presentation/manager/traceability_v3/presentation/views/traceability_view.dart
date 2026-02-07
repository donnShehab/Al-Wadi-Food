import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';

import '../../domain/repositories/traceability_repository.dart';
import '../cubit/traceability_cubit.dart';
import '../cubit/traceability_state.dart';
import 'recall_audit_viewer_view.dart';
import 'traceability_view_body.dart';

class TraceabilityView extends StatefulWidget {
  /// If null/empty => picker mode
  /// If non-empty  => graph mode
  final String? rootNodeId;

  const TraceabilityView({super.key, this.rootNodeId});

  @override
  State<TraceabilityView> createState() => _TraceabilityViewState();
}

class _TraceabilityViewState extends State<TraceabilityView> {
  late final TraceabilityV3Repository _repository;
  late final TraceabilityCubit _cubit;

  String? get _normalizedRoot {
    final v = widget.rootNodeId;
    if (v == null) return null;
    final trimmed = v.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  bool _canManageRecalls(String role) {
    // Keep original business rule here (UI gate only).
    return role == 'Admin' || role == 'Manager';
  }

  @override
  void initState() {
    super.initState();
    _repository = getIt<TraceabilityV3Repository>();
    _cubit = TraceabilityCubit(_repository);

    final root = _normalizedRoot;
    if (root != null) {
      _cubit.loadGraph(root);
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Traceability'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            if (_normalizedRoot != null)
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () => _cubit.loadGraph(_normalizedRoot!),
              ),
            if (isAuthorized)
              IconButton(
                icon: const Icon(Icons.history_rounded),
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
        body: DecoratedBox(
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
          child: SafeArea(
            top: false,
            child: _normalizedRoot == null
                ? const _TraceabilityBatchPicker()
                : BlocConsumer<TraceabilityCubit, TraceabilityState>(
                    listener: (context, state) {
                      if (state is TraceabilityRecallExecuted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Recall executed successfully'),
                          ),
                        );
                      } else if (state is TraceabilityError) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      if (state is TraceabilityInitial ||
                          state is TraceabilityLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final auth = context.watch<AuthCubit>().state;
                      if (auth is! AuthSuccess) {
                        return const Center(
                          child: Text('You must be logged in'),
                        );
                      }

                      final user = auth.user;

                      return TraceabilityViewBody(
                        state: state,
                        rootNodeId: _normalizedRoot!,
                        managerId: user.uid,
                        managerName: user.name,
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

class _TraceabilityBatchPicker extends StatelessWidget {
  const _TraceabilityBatchPicker();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Select a batch from Action Center or Reports\n'
        'to view traceability',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
