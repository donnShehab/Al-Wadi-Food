import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/audit_history_cubit.dart';

class RecallAuditHistoryScreen extends StatelessWidget {
  const RecallAuditHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => context.read<AuditHistoryCubit>()..loadAudits(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Recall Audit History')),
        body: BlocBuilder<AuditHistoryCubit, AuditHistoryState>(
          builder: (context, state) {
            if (state is AuditHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AuditHistoryLoaded) {
              return ListView.separated(
                itemCount: state.audits.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final audit = state.audits[i];

                  return ListTile(
                    leading: Icon(
                      Icons.warning_amber_rounded,
                      color: audit.severity == 'CRITICAL'
                          ? Colors.red
                          : Colors.orange,
                    ),
                    title: Text('Source: ${audit.sourceNodeId}'),
                    subtitle: Text(
                      'Severity: ${audit.severity}\n'
                      'Impacted: ${audit.impactedCount}',
                    ),
                    trailing: Text(
                      audit.executedAt.toLocal().toString().split('.').first,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              );
            }

            if (state is AuditHistoryError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
