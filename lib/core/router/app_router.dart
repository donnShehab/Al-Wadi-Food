

import 'package:alwadi_food/presentation/qc/presentation/views/qc_pending_list_view.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_dashboard/qc_dashboard_view.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_details/qc_details_view.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_history/qc_history_view.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/widgets/qc_inspection/qc_inspection_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ---------- AUTH ----------
import 'package:alwadi_food/presentation/auth/presentaion/signin/views/signin_view.dart';
import 'package:alwadi_food/presentation/auth/presentaion/signup/views/signup_view.dart';

/// ---------- CORE ----------
import 'package:alwadi_food/presentation/splash/presntation/views/splash_view.dart';
import 'package:alwadi_food/presentation/home/presentation/views/home_view.dart';
import 'package:alwadi_food/presentation/settings/views/settings_view.dart';

/// ---------- PRODUCTION ----------
import 'package:alwadi_food/presentation/production/presentation/views/create_batch_view.dart';
import 'package:alwadi_food/presentation/production/presentation/views/batch_list_view.dart';
import 'package:alwadi_food/presentation/production/presentation/views/batch_details_view.dart';

/// ---------- QC ----------

/// ---------- MANAGER ----------
import 'package:alwadi_food/presentation/manager/presentation/views/dashboard_view.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/traceability_view.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/user_management_view.dart';

class AppRouter {
  // ================= ROUTE NAMES =================
  static const String KsplashView = '/splash';
  static const String KloginView = '/login';
  static const String KSignup = '/signup';
  static const String KhomeView = '/home';
  static const String KQCInspectionView = '/qc-inspection';
  static const String KcreateBatchView = '/create-batch';
  static const String KbatchListView = '/batches';
  static const String KbatchDetailsView = '/batch-details';
  static const String KQCDashboardView = '/qc-dashboard';

  static const String KqCPendingListView = '/qc-pending';
  static const String KQCHistoryView = '/qc-history';
  static const String KdashboardView = '/dashboard';
  static const String KtraceabilityView = '/traceability';
  static const String KuserManagementView = '/users';
  static const String KQCDetailsView = "/kqcdetailsview";
  static const String KsettingsView = '/settings';

  // ================= ROUTER =================
  static final GoRouter router = GoRouter(
    initialLocation: KsplashView,
    routes: [
      /// -------- SPLASH --------
      GoRoute(
        path: KsplashView,
        pageBuilder: (context, state) => fadeOnly(state, const SplashView()),
      ),

      /// -------- AUTH --------
      GoRoute(
        path: KloginView,
        pageBuilder: (context, state) => fadeOnly(state, const SigninView()),
      ),
      GoRoute(
        path: KSignup,
        pageBuilder: (context, state) => fadeOnly(state, const SignupView()),
      ),

      /// -------- HOME --------
      GoRoute(
        path: KhomeView,
        pageBuilder: (context, state) => fadeUp(state, const HomeView()),
      ),

      /// -------- PRODUCTION --------
      GoRoute(
        path: KbatchListView,
        pageBuilder: (context, state) => fadeUp(state, const BatchListView()),
      ),
      GoRoute(
        path: KcreateBatchView,
        pageBuilder: (context, state) =>
            slideFromRight(state, const CreateBatchView()),
      ),
      GoRoute(
        path: '$KbatchDetailsView/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return slideFromRight(state, BatchDetailsView(batchId: id));
        },
      ),

      /// -------- QC --------
      GoRoute(
        path: KqCPendingListView,
        pageBuilder: (context, state) =>
            fadeUp(state, const QCPendingListView()),
      ),
  GoRoute(
        path: '/qc-history/:batchId',
        builder: (context, state) {
          final batchId = state.pathParameters['batchId']!;
          return QCHistoryView(batchId: batchId);
        },
      ),


      GoRoute(
        path: '$KQCInspectionView/:batchId',
        pageBuilder: (context, state) {
          final batchId = state.pathParameters['batchId']!;
          return buildFadeSlidePage(
            state: state,
            child: QCInspectionView(batchId: batchId),
          );
        },
      ),

      /// -------- QC --------
      GoRoute(
        path: KQCDashboardView,
        pageBuilder: (context, state) => fadeUp(state, const QCDashboardView()),
      ),
        GoRoute(
        path: KQCDetailsView,
        pageBuilder: (context, state) {
          final inspectionId = state.pathParameters['inspectionId']!;

          return slideFromRight(
            state,
            QCDetailsView(inspectionId: inspectionId),
          );
        },
      ),
  
      /// -------- MANAGER --------
      GoRoute(
        path: KdashboardView,
        pageBuilder: (context, state) => fadeUp(state, const DashboardView()),
      ),
      GoRoute(
        path: KtraceabilityView,
        pageBuilder: (context, state) =>
            fadeUp(state, const TraceabilityView()),
      ),
      GoRoute(
        path: KuserManagementView,
        pageBuilder: (context, state) =>
            fadeUp(state, const UserManagementView()),
      ),

      /// -------- SETTINGS --------
      GoRoute(
        path: KsettingsView,
        pageBuilder: (context, state) => fadeUp(state, const SettingsView()),
      ),
    ],
  );

  // ================= TRANSITIONS =================

  /// Fade only (Splash / Auth)
  static CustomTransitionPage<T> fadeOnly<T>(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      child: child,
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }

  /// Fade + slide up (Home / Lists / Dashboards)
  static CustomTransitionPage<T> fadeUp<T>(GoRouterState state, Widget child) {
    return buildFadeSlidePage(
      state: state,
      child: child,
      begin: const Offset(0, 0.08),
      duration: const Duration(milliseconds: 380),
    );
  }

  /// Slide from right (Details / Create / Deep pages)
  static CustomTransitionPage<T> slideFromRight<T>(
    GoRouterState state,
    Widget child,
  ) {
    return buildFadeSlidePage(
      state: state,
      child: child,
      begin: const Offset(1.0, 0),
      duration: const Duration(milliseconds: 420),
    );
  }

  /// Base transition builder (مش مستخدمة مباشرة)
  static CustomTransitionPage<T> buildFadeSlidePage<T>({
    required GoRouterState state,
    required Widget child,
    Offset begin = const Offset(0, 0.08),
    Duration duration = const Duration(milliseconds: 380),
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      transitionDuration: duration,
      reverseTransitionDuration: const Duration(milliseconds: 300),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: begin,
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
