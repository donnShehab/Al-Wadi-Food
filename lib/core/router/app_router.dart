import 'package:alwadi_food/presentation/auth/presentaion/signin/views/signin_view.dart';
import 'package:alwadi_food/presentation/auth/presentaion/signup/views/signup_view.dart';
import 'package:alwadi_food/presentation/home/presentation/views/home_view.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/dashboard_view.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/traceability_view.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/user_management_view.dart';
import 'package:alwadi_food/presentation/production/presentation/views/batch_details_view.dart';
import 'package:alwadi_food/presentation/production/presentation/views/batch_list_view.dart';
import 'package:alwadi_food/presentation/production/presentation/views/create_batch_view.dart';

import 'package:alwadi_food/presentation/qc/presentation/views/qc_history_view.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/qc_inspection_view.dart';
import 'package:alwadi_food/presentation/qc/presentation/views/qc_pending_list_view.dart';
import 'package:alwadi_food/presentation/settings/views/settings_view.dart';
import 'package:alwadi_food/presentation/splash/presntation/views/splash_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const KsplashView = '/';
  static const KloginView = '/login';
  static const KsignupView = '/signup';
  static const KhomeView = '/home';
  static const KcreateBatchView = '/create-batch';
  static const KbatchListView = '/batch-list';
  static const KbatchDetailsView = '/batch-details/:batchId';
  static const KqCPendingListView = '/qc-pending';
  static const KqCInspectionView = '/qc-inspection/:batchId';
  static const KqCHistoryView = '/qc-history/:batchId';
  static const KdashboardView = '/dashboard';
  static const KtraceabilityView = '/traceability';
  static const KuserManagementView = '/user-management';
  static const KsettingsView = '/settings';
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: KsplashView,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: KloginView,
        builder: (context, state) => const SigninView(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupView(),
      ),

      GoRoute(path: '/home', builder: (context, state) => const HomeView()),
      GoRoute(
        path: '/create-batch',
        builder: (context, state) => const CreateBatchView(),
      ),
      GoRoute(
        path: '/batch-list',
        builder: (context, state) => const BatchListView(),
      ),
      GoRoute(
        path: '/batch-details/:batchId',
        builder: (context, state) {
          final batchId = state.pathParameters['batchId']!;
          return BatchDetailsView(batchId: batchId);
        },
      ),
      GoRoute(
        path: '/qc-pending',
        builder: (context, state) => const QCPendingListView(),
      ),
      GoRoute(
        path: '/qc-inspection/:batchId',
        builder: (context, state) {
          final batchId = state.pathParameters['batchId']!;
          return QCInspectionView(batchId: batchId);
        },
      ),
      GoRoute(
        path: '/qc-history/:batchId',
        builder: (context, state) {
          final batchId = state.pathParameters['batchId']!;
          return QCHistoryView(batchId: batchId);
        },
      ),
      // GoRoute(
      //   path: '/dashboard',
      //   builder: (context, state) => const DashboardView(),
      // ),
      GoRoute(
        path: '/traceability',
        builder: (context, state) => const TraceabilityView(),
      ),
      // GoRoute(
      //   path: '/user-management',
      //   builder: (context, state) => const UserManagementView(),
      // ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsView(),
      ),
    ],
  );
}
