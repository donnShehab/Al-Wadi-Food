import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alwadi_food/theme.dart';
import '../../cubit/traceability_cubit.dart';
import '../../cubit/traceability_state.dart';
import '../../utils/trace_manager_decisions.dart';

class TraceDecisionBar extends StatelessWidget {
  const TraceDecisionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TraceabilityCubit, TraceabilityState>(
      buildWhen: (p, n) =>
          p.isSubmittingDecision != n.isSubmittingDecision ||
          p.decisionError != n.decisionError ||
          p.selectedBundle?.batch.managerDecision !=
              n.selectedBundle?.batch.managerDecision ||
          p.selectedBundle?.batch.managerDecisionNote !=
              n.selectedBundle?.batch.managerDecisionNote,
      builder: (context, state) {
        final bundle = state.selectedBundle;
        if (bundle == null) return const SizedBox.shrink();

        final scheme = Theme.of(context).colorScheme;
        final disabled = state.isSubmittingDecision;

        final currentDecision = bundle.batch.managerDecision;
        final currentDecisionLabel = _decisionLabel(currentDecision);
        final currentNote = bundle.batch.managerDecisionNote?.trim();

        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              12,
              AppSpacing.md,
              12,
            ),
            decoration: BoxDecoration(
              color: scheme.surface,
              border: Border(
                top: BorderSide(color: scheme.outline.withOpacity(0.20)),
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 18,
                  offset: Offset(0, -6),
                  color: Color(0x14000000),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.decisionError != null &&
                    state.decisionError!.trim().isNotEmpty) ...[
                  _errorPill(context, state.decisionError!),
                  const SizedBox(height: 10),
                ],
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentDecisionLabel == null
                            ? 'Manager decision'
                            : 'Decision: $currentDecisionLabel',
                        style: Theme.of(context).textTheme.titleSmall?.bold,
                      ),
                    ),
                    if (disabled)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                if (currentNote != null && currentNote.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Note: $currentNote',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface.withOpacity(0.78),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed:
                            (disabled ||
                                currentDecision ==
                                    TraceManagerDecisions.approved)
                            ? null
                            : () => _askAndSubmit(
                                context,
                                decision: TraceManagerDecisions.approved,
                              ),
                        icon: const Icon(Icons.check_circle_rounded),
                        label: const Text('Approve'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            (disabled ||
                                currentDecision == TraceManagerDecisions.hold)
                            ? null
                            : () => _askAndSubmit(
                                context,
                                decision: TraceManagerDecisions.hold,
                              ),
                        icon: const Icon(Icons.pause_circle_rounded),
                        label: const Text('Hold'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed:
                            (disabled ||
                                currentDecision ==
                                    TraceManagerDecisions.rejected)
                            ? null
                            : () => _askAndSubmit(
                                context,
                                decision: TraceManagerDecisions.rejected,
                              ),
                        icon: const Icon(Icons.cancel_rounded),
                        label: const Text('Reject'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? _decisionLabel(String? d) {
    if (d == null || d.trim().isEmpty) return null;
    switch (d) {
      case TraceManagerDecisions.approved:
        return 'Approved';
      case TraceManagerDecisions.rejected:
        return 'Rejected';
      case TraceManagerDecisions.hold:
        return 'Hold';
      default:
        return d;
    }
  }

  Future<void> _askAndSubmit(
    BuildContext context, {
    required String decision,
  }) async {
    final rootContext = context;

    final cubit = rootContext.read<TraceabilityCubit>();
    final bundle = cubit.state.selectedBundle;
    if (bundle == null) return;

    final existingDecision = bundle.batch.managerDecision;
    final isOverride =
        existingDecision != null &&
        existingDecision.trim().isNotEmpty &&
        existingDecision != decision;

    if (isOverride) {
      final confirmed = await _overrideConfirmDialog(
        rootContext,
        currentLabel: _decisionLabel(existingDecision) ?? existingDecision,
        nextLabel: _decisionLabel(decision) ?? decision,
      );
      if (confirmed != true) return;
    }

    final note = await _noteDialog(
      rootContext,
      decision: decision,
      forceRequiredNote: isOverride,
    );
    if (note == null) return;

    // let dialog teardown complete
    await Future.delayed(const Duration(milliseconds: 20));
    if (!rootContext.mounted) return;

    await rootContext.read<TraceabilityCubit>().submitManagerDecision(
      decision: decision,
      note: note,
    );

    if (!rootContext.mounted) return;

    // SnackBar next frame (safe)
    final st = rootContext.read<TraceabilityCubit>().state;
    final ok = st.decisionError == null || st.decisionError!.trim().isEmpty;
    if (ok) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!rootContext.mounted) return;
        ScaffoldMessenger.of(rootContext).showSnackBar(
          const SnackBar(content: Text('Decision saved successfully')),
        );
      });
    }
  }

  Future<bool?> _overrideConfirmDialog(
    BuildContext rootContext, {
    required String currentLabel,
    required String nextLabel,
  }) async {
    final theme = Theme.of(rootContext);
    final scheme = theme.colorScheme;

    return showDialog<bool>(
      context: rootContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Override existing decision?'),
          content: Text(
            'This batch already has a decision: $currentLabel.\n\n'
            'Do you want to override it with: $nextLabel?\n\n'
            'A note will be required.',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface.withOpacity(0.85),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Override'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _noteDialog(
    BuildContext rootContext, {
    required String decision,
    required bool forceRequiredNote,
  }) async {
    final theme = Theme.of(rootContext);
    final scheme = theme.colorScheme;

    final ctrl = TextEditingController();
    String? inlineError;

    final title = decision == TraceManagerDecisions.approved
        ? 'Approve batch'
        : decision == TraceManagerDecisions.rejected
        ? 'Reject batch'
        : 'Place on hold';

    final bool requiredNote =
        forceRequiredNote || (decision != TraceManagerDecisions.approved);

    final hint = requiredNote
        ? 'Required note (short reason)'
        : 'Optional note (e.g., approved after evidence review)';

    final result = await showDialog<String>(
      context: rootContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: ctrl,
                    maxLines: 3,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: hint,
                      errorText: inlineError,
                    ),
                  ),
                  if (requiredNote) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Note is required for Hold/Reject (and when overriding).',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface.withOpacity(0.70),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    FocusScope.of(dialogContext).unfocus();
                    Navigator.of(dialogContext).pop(null);
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    final note = ctrl.text.trim();
                    if (requiredNote && note.length < 3) {
                      setState(
                        () => inlineError =
                            'Please enter a short note (min 3 chars).',
                      );
                      return;
                    }
                    FocusScope.of(dialogContext).unfocus();
                    await Future.delayed(const Duration(milliseconds: 20));
                    Navigator.of(dialogContext).pop(note);
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );

    ctrl.dispose();
    return result;
  }

  Widget _errorPill(BuildContext context, String error) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.error.withOpacity(0.10),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.error.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: scheme.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              error,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
