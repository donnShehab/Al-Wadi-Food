// // presentation/views/traceability_view.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:alwadi_food/core/di/injection.dart';

// import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
// import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';

// import '../cubit/traceability_cubit.dart';
// import '../cubit/traceability_state.dart';
// import 'traceability_view_body.dart';
// import 'recall_audit_viewer_view.dart';

// import '../../domain/repositories/traceability_repository.dart';

// class TraceabilityView extends StatelessWidget {
//   final String rootNodeId;

//   const TraceabilityView({super.key, required this.rootNodeId});

//   bool _canManageRecalls(String role) {
//     return role == 'Admin' || role == 'Manager';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = context.watch<AuthCubit>().state;

//     final bool isAuthorized =
//         authState is AuthSuccess && _canManageRecalls(authState.user.role);

//     /// ✅ Get repository from GetIt (V3)
//     final TraceabilityV3Repository repository =
//         getIt<TraceabilityV3Repository>();

//     return BlocProvider<TraceabilityCubit>(
//       create: (_) {
//         final cubit = TraceabilityCubit(repository);

//         /// ✅ Correct initialization method
//         /// If your Cubit has `loadGraph`, we use it.
//         /// (If later renamed to init(), change only this line.)
//         cubit.loadGraph(rootNodeId);

//         return cubit;
//       },

//       /// ✅ Builder fixes provider scope issues
//       child: Builder(
//         builder: (scaffoldContext) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Traceability'),

//               /// ============================================================
//               /// 🕘 AUDIT HISTORY (RBAC PROTECTED)
//               /// ============================================================
//               actions: [
//                 if (isAuthorized)
//                   IconButton(
//                     icon: const Icon(Icons.history),
//                     tooltip: 'Recall Audit History',
//                     onPressed: () {
//                       Navigator.push(
//                         scaffoldContext,
//                         MaterialPageRoute(
//                           builder: (_) =>
//                               RecallAuditViewerView(repository: repository),
//                         ),
//                       );
//                     },
//                   ),
//               ],
//             ),

//             body: BlocConsumer<TraceabilityCubit, TraceabilityState>(
//               listener: (context, state) {
//                 if (state is TraceabilityRecallExecuted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Recall executed successfully'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 }

//                 if (state is TraceabilityError) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(state.message),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },

//               builder: (context, traceState) {
//                 /// ============================================================
//                 /// ⏳ LOADING / INITIAL
//                 /// ============================================================
//                 if (traceState is TraceabilityInitial ||
//                     traceState is TraceabilityLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 /// ============================================================
//                 /// 📊 MAIN BODY
//                 /// ============================================================
//                 return TraceabilityViewBody(
//                   state: traceState,
//                   rootNodeId: rootNodeId,

//                   /// ============================================================
//                   /// 🔐 EXECUTE RECALL (RBAC + AUTH)
//                   /// ============================================================
//                   onConfirmRecall: (recallResult) {
//                     final authState = context.read<AuthCubit>().state;

//                     if (authState is! AuthSuccess) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('You must be logged in'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                       return;
//                     }

//                     final user = authState.user;

//                     if (!_canManageRecalls(user.role)) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text(
//                             'You are not authorized to execute recalls',
//                           ),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                       return;
//                     }

//                     context.read<TraceabilityCubit>().executeRecall(
//                       recallResult: recallResult,
//                       managerId: user.uid,
//                       managerName: user.name,
//                     );
//                   },
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// presentation/traceability/traceability_view.dart
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
    // return role == 'Admin' || role == 'Manager';
      return true; // TEMP: allow recall execution for testing
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
      _cubit.loadGraph(root); // ✅ auto-load immediately
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
    final authState = context.watch<AuthCubit>().state;
    final bool isAuthorized =
        authState is AuthSuccess && _canManageRecalls(authState.user.role);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Traceability'),
          actions: [
            if (isAuthorized)
              IconButton(
                icon: const Icon(Icons.history),
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
        body: _normalizedRoot == null
            ? const _TraceabilityBatchPicker()
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
                    return const Center(child: CircularProgressIndicator());
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
