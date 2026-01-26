// presentation/widgets/recall_empty_state.dart

import 'package:flutter/material.dart';

class RecallEmptyState extends StatelessWidget {
  const RecallEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Load a batch to view traceability',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
