import 'package:alwadi_food/core/di/injection.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_cubit.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_action/manager_action_needed_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagerActionNeededView extends StatelessWidget {
  const ManagerActionNeededView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ManagerActionNeededCubit>()..loadActionNeeded(),
      child: const _ManagerActionNeededScaffold(),
    );
  }
}

class _ManagerActionNeededScaffold extends StatefulWidget {
  const _ManagerActionNeededScaffold();

  @override
  State<_ManagerActionNeededScaffold> createState() =>
      _ManagerActionNeededScaffoldState();
}

class _ManagerActionNeededScaffoldState
    extends State<_ManagerActionNeededScaffold> {
  DateTime? lastUpdated;

  @override
  void initState() {
    super.initState();
    lastUpdated = DateTime.now();
  }

  Future<void> _refresh() async {
    await context.read<ManagerActionNeededCubit>().loadActionNeeded();
    if (mounted) {
      setState(() => lastUpdated = DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      /// ✅ Professional AppBar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Action Center",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Items that require immediate action",
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Refresh",
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded, color: Colors.black87),
          ),
          const SizedBox(width: 6),
        ],
      ),

      /// ✅ Pull-to-refresh
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ManagerActionNeededViewBody(
            lastUpdated: lastUpdated,
            onRefreshTap: _refresh,
          ),
        ),
      ),
    );
  }
}
