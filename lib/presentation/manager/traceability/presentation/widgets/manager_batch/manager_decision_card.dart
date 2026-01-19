import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/core/utils/date_formatter.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/domain/entities/production_batch_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagerDecisionCard extends StatefulWidget {
  final ProductionBatchEntity batch;

  const ManagerDecisionCard({super.key, required this.batch});

  @override
  State<ManagerDecisionCard> createState() => _ManagerDecisionCardState();
}

class _ManagerDecisionCardState extends State<ManagerDecisionCard> {
  String? _selectedDecision; // "approved" | "hold" | "rejected"
  final TextEditingController _noteController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  bool get _noteRequired {
    return _selectedDecision == 'hold' || _selectedDecision == 'rejected';
  }

  bool get _canSubmit {
    if (_isSubmitting) return false;
    if (_selectedDecision == null) return false;
    if (_noteRequired) {
      return _noteController.text.trim().isNotEmpty;
    }
    return true;
  }

  Future<void> _submitDecision(BuildContext context) async {
    if (!_canSubmit) return;
    if (_isSubmitting) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not signed in.')));
      return;
    }

    final decision = _selectedDecision!;
    final note = _noteController.text.trim();

    setState(() {
      _isSubmitting = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;

      // Resolve manager name from users/{uid}.name (fallback to Firebase displayName)
      String managerName = user.displayName ?? 'Manager';
      try {
        final userDoc = await firestore
            .collection(AppConstants.usersCollection)
            .doc(user.uid)
            .get();
        final data = userDoc.data();
        final nameFromDb = data == null ? null : (data['name'] as String?);
        if (nameFromDb != null && nameFromDb.trim().isNotEmpty) {
          managerName = nameFromDb.trim();
        }
      } catch (_) {
        // ignore, keep fallback managerName
      }

      final batchRef = firestore
          .collection(AppConstants.batchesCollection)
          .doc(widget.batch.batchId);

      final traceEventsRef = firestore.collection(
        AppConstants.traceEventsCollection,
      );

      await firestore.runTransaction((tx) async {
        // A) update production_batches (merge/update only)
        tx.update(batchRef, {
          'managerDecisionStatus': decision,
          'managerDecisionAt': FieldValue.serverTimestamp(),
          'managerDecisionById': user.uid,
          'managerDecisionByName': managerName,
          'managerDecisionNote': note.isEmpty ? null : note,
        });

        // B) append trace event (immutable)
        final newEventRef = traceEventsRef.doc();
        tx.set(newEventRef, {
          'batchId': widget.batch.batchId,
          'type': 'manager_decision',
          'createdAt': FieldValue.serverTimestamp(),
          'actorRole': 'manager',
          'actorId': user.uid,
          'actorName': managerName,
          'payload': {'status': decision, 'note': note.isEmpty ? null : note},
        });
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Decision submitted successfully.')),
      );

      // Reload batch to show read-only decision state
      context.read<ProductionCubit>().loadBatchById(widget.batch.batchId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit decision: $e')));
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final batch = widget.batch;

    final existingDecision = batch.managerDecisionStatus;
    final hasExistingDecision =
        existingDecision != null && existingDecision.trim().isNotEmpty;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manager Decision',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            if (hasExistingDecision) ...[
              _DecisionReadOnlyView(batch: batch),
            ] else ...[
              _DecisionActionsView(
                selectedDecision: _selectedDecision,
                isSubmitting: _isSubmitting,
                onSelect: (value) {
                  if (_isSubmitting) return;
                  setState(() {
                    _selectedDecision = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                enabled: !_isSubmitting,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Decision Note',
                  hintText: _noteRequired
                      ? 'Required for Hold/Reject'
                      : 'Optional for Approve',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _canSubmit ? () => _submitDecision(context) : null,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit Decision'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DecisionActionsView extends StatelessWidget {
  final String? selectedDecision;
  final bool isSubmitting;
  final ValueChanged<String> onSelect;

  const _DecisionActionsView({
    required this.selectedDecision,
    required this.isSubmitting,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DecisionButton(
            label: 'Approve',
            value: 'approved',
            selected: selectedDecision == 'approved',
            enabled: !isSubmitting,
            onPressed: () => onSelect('approved'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _DecisionButton(
            label: 'Hold',
            value: 'hold',
            selected: selectedDecision == 'hold',
            enabled: !isSubmitting,
            onPressed: () => onSelect('hold'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _DecisionButton(
            label: 'Reject',
            value: 'rejected',
            selected: selectedDecision == 'rejected',
            enabled: !isSubmitting,
            onPressed: () => onSelect('rejected'),
          ),
        ),
      ],
    );
  }
}

class _DecisionButton extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final bool enabled;
  final VoidCallback onPressed;

  const _DecisionButton({
    required this.label,
    required this.value,
    required this.selected,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(
          color: selected ? theme.colorScheme.primary : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),
        backgroundColor: selected
            ? theme.colorScheme.primary.withOpacity(0.08)
            : Colors.white,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: selected ? theme.colorScheme.primary : Colors.black87,
        ),
      ),
    );
  }
}

class _DecisionReadOnlyView extends StatelessWidget {
  final ProductionBatchEntity batch;

  const _DecisionReadOnlyView({required this.batch});

  String _formatDecision(String value) {
    switch (value) {
      case 'approved':
        return 'Approved';
      case 'hold':
        return 'Hold';
      case 'rejected':
        return 'Rejected';
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decision = batch.managerDecisionStatus ?? '';

    final lines = <Widget>[];

    lines.add(
      _InfoRow(
        label: 'Decision',
        value: _formatDecision(decision),
        valueStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (batch.managerDecisionAt != null) {
      lines.add(
        _InfoRow(
          label: 'Date',
          value: DateFormatter.formatDateTime(batch.managerDecisionAt!),
        ),
      );
    }

    if (batch.managerDecisionByName != null &&
        batch.managerDecisionByName!.trim().isNotEmpty) {
      lines.add(
        _InfoRow(label: 'Manager', value: batch.managerDecisionByName!.trim()),
      );
    }

    if (batch.managerDecisionNote != null &&
        batch.managerDecisionNote!.trim().isNotEmpty) {
      lines.add(const SizedBox(height: 10));
      lines.add(
        Text(
          'Note',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      );
      lines.add(const SizedBox(height: 6));
      lines.add(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F9FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            batch.managerDecisionNote!.trim(),
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _InfoRow({required this.label, required this.value, this.valueStyle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: valueStyle ?? theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
