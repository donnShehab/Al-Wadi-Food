// import 'dart:async';

// import 'package:alwadi_food/core/di/injection.dart';
// import 'package:alwadi_food/theme.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../cubit/traceability_cubit.dart';
// import '../tabs/traceability_alerts_tab.dart';
// import '../tabs/traceability_dashboard_tab.dart';
// import '../tabs/traceability_search_tab.dart';
// import '../tabs/traceability_timeline_tab.dart';
// import '../widgets/trace_app_bar.dart';

// class TraceabilityCenterScreen extends StatefulWidget {
//   final String? initialBatchId;
//   final bool standalone;

//   const TraceabilityCenterScreen({
//     super.key,
//     this.initialBatchId,
//     this.standalone = false,
//   });

//   @override
//   State<TraceabilityCenterScreen> createState() =>
//       _TraceabilityCenterScreenState();
// }

// class _TraceabilityCenterScreenState extends State<TraceabilityCenterScreen> {
//   late final TraceabilityCubit _cubit;
//   Future<void>? _bootstrap;

//   bool _listenerAttached = false;

//   static const int _alertsIndex = 0;
//   static const int _searchIndex = 1;
//   static const int _timelineIndex = 2;
//   static const int _dashboardIndex = 3;

//   @override
//   void initState() {
//     super.initState();
//     _cubit = getIt<TraceabilityCubit>();
//     _bootstrap = _initOnce();
//   }

//   Future<void> _initOnce() async {
//     final auth = FirebaseAuth.instance;
//     if (auth.currentUser == null) {
//       await auth.authStateChanges().firstWhere((u) => u != null);
//     }

//     // ✅ Start clean: Timeline empty until user selects
//     _cubit.clearSelected();

//     await _cubit.init();

//     final initial = widget.initialBatchId?.trim();
//     if (initial != null && initial.isNotEmpty) {
//       await _cubit.openBatch(initial);
//     }
//   }

//   void _attachTabListener(BuildContext context) {
//     if (_listenerAttached) return;

//     final controller = DefaultTabController.of(context);

//     controller.addListener(() {
//       if (controller.indexIsChanging) return;

//       // ✅ Clear selection when leaving Timeline OR when entering Search
//       // This prevents stale batch showing in Timeline unless user selects again.
//       if (controller.index == _alertsIndex ||
//           controller.index == _searchIndex ||
//           controller.index == _dashboardIndex) {
//         _cubit.clearSelected();
//       }
//     });

//     // If deep-linked, auto-jump to Timeline after first frame
//     if (widget.initialBatchId != null &&
//         widget.initialBatchId!.trim().isNotEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!mounted) return;
//         DefaultTabController.of(context).animateTo(_timelineIndex);
//       });
//     }

//     _listenerAttached = true;
//   }

//   @override
//   void dispose() {
//     _cubit.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _cubit,
//       child: FutureBuilder<void>(
//         future: _bootstrap,
//         builder: (context, snap) {
//           if (snap.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           }

//           return DefaultTabController(
//             length: 4,
//             child: Builder(
//               builder: (ctx) {
//                 _attachTabListener(ctx);

//                 return Scaffold(
//                   appBar: TraceAppBar(
//                     title: "Traceability Center",
//                     onBack: widget.standalone
//                         ? () => Navigator.of(context).maybePop()
//                         : null,
//                   ),
//                   body: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(
//                           AppSpacing.md,
//                           0,
//                           AppSpacing.md,
//                           AppSpacing.md,
//                         ),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).colorScheme.surface,
//                             borderRadius: BorderRadius.circular(AppRadius.lg),
//                             border: Border.all(
//                               color: Theme.of(
//                                 context,
//                               ).colorScheme.outline.withOpacity(0.25),
//                             ),
//                           ),
//                           child: TabBar(
//                             dividerColor: Colors.transparent,
//                             indicatorSize: TabBarIndicatorSize.tab,
//                             labelStyle: Theme.of(
//                               context,
//                             ).textTheme.labelLarge?.bold,
//                             tabs: const [
//                               Tab(
//                                 icon: Icon(Icons.notifications_rounded),
//                                 text: "Alerts",
//                               ),
//                               Tab(
//                                 icon: Icon(Icons.search_rounded),
//                                 text: "Search",
//                               ),
//                               Tab(
//                                 icon: Icon(Icons.timeline_rounded),
//                                 text: "Timeline",
//                               ),
//                               Tab(
//                                 icon: Icon(Icons.analytics_rounded),
//                                 text: "Dashboard",
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const Expanded(
//                         child: TabBarView(
//                           children: [
//                             TraceabilityAlertsTab(),
//                             TraceabilitySearchTab(),
//                             TraceabilityTimelineTab(),
//                             TraceabilityDashboardTab(),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
