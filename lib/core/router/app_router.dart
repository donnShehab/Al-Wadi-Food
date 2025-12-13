

import 'package:alwadi_food/presentation/auth/presentaion/signin/views/signin_view.dart';
import 'package:alwadi_food/presentation/auth/presentaion/signup/views/signup_view.dart';
import 'package:alwadi_food/presentation/home/presentation/views/home_view.dart';
import 'package:alwadi_food/presentation/settings/views/settings_view.dart';
import 'package:alwadi_food/presentation/splash/presntation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ---------- Import Your Views ----------
import 'package:alwadi_food/presentation/production/presentation/views/create_batch_view.dart';
import 'package:alwadi_food/presentation/production/presentation/views/batch_list_view.dart';
import 'package:alwadi_food/presentation/production/presentation/views/batch_details_view.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/qc_pending_list_view.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/dashboard_view.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/traceability_view.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/user_management_view.dart';

class AppRouter {
  static const String KsplashView = '/splash';
  static const String KloginView = '/login';
  static const String KSignup = '/Signup';
  static const String KhomeView = '/home';

  static const String KcreateBatchView = '/create-batch';
  static const String KbatchListView = '/batches';
  static const String KbatchDetailsView = '/batch-details';

  static const String KqCPendingListView = '/qc-pending';

  static const String KdashboardView = '/dashboard';
  static const String KtraceabilityView = '/traceability';
  static const String KuserManagementView = '/users';

  static const String KsettingsView = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: KsplashView, // ← ← أهم سطر!
    routes: [
      /// SPLASH
      GoRoute(
        path: KsplashView,
        pageBuilder: (context, state) =>
            _transition(context, state, const SplashView()),
      ),

      /// LOGIN
      GoRoute(
        path: KloginView,
        pageBuilder: (context, state) =>
            _transition(context, state, const SigninView()),
      ),
      GoRoute(
        path: KSignup,
        pageBuilder: (context, state) =>
            _transition(context, state, const SignupView()),
      ),

      /// HOME
      GoRoute(
        path: KhomeView,
        pageBuilder: (context, state) =>
            _transition(context, state, const HomeView()),
      ),

      /// CREATE BATCH
      GoRoute(
        path: KcreateBatchView,
        pageBuilder: (context, state) =>
            _transition(context, state, const CreateBatchView()),
      ),

      /// BATCH LIST
      GoRoute(
        path: KbatchListView,
        pageBuilder: (context, state) =>
            _transition(context, state, const BatchListView()),
      ),

      /// BATCH DETAILS
      GoRoute(
        path: '$KbatchDetailsView/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return _transition(context, state, BatchDetailsView(batchId: id));
        },
      ),

      /// QC
      GoRoute(
        path: KqCPendingListView,
        pageBuilder: (context, state) =>
            _transition(context, state, const QCPendingListView()),
      ),

      /// MANAGER
      GoRoute(
        path: KdashboardView,
        pageBuilder: (context, state) =>
            _transition(context, state, const DashboardView()),
      ),
      GoRoute(
        path: KtraceabilityView,
        pageBuilder: (context, state) =>
            _transition(context, state, const TraceabilityView()),
      ),
      GoRoute(
        path: KuserManagementView,
        pageBuilder: (context, state) =>
            _transition(context, state, const UserManagementView()),
      ),

      /// SETTINGS
      GoRoute(
        path: KsettingsView,
        pageBuilder: (context, state) =>
            _transition(context, state, const SettingsView()),
      ),
    ],
  );

  static CustomTransitionPage _transition(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondary, widget) {
final fade = Tween(begin: 0.9, end: 1.0).animate(animation);
        final slide = Tween(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: slide, child: widget),
        );
      },
    );
  }
}
