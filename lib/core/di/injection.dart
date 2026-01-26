import 'package:alwadi_food/core/services/preferences_service.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/auth/data/repos/auth_repository_impl.dart';
import 'package:alwadi_food/presentation/auth/data/repos/user_repository_impl.dart';
import 'package:alwadi_food/presentation/auth/data/services/firebase_auth_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/firestore_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/manager_dashboard_firestore_ds.dart';
import 'package:alwadi_food/presentation/auth/data/services/manager_kpi_list_firestore_ds.dart';
import 'package:alwadi_food/presentation/auth/data/services/qc_pdf_report_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/reports_excel_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/reports_pdf_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/storage_service.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/user_repository.dart';
import 'package:alwadi_food/presentation/home/cubit/home_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/dashboard_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_action/manager_action_needed_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_dashboard/manager_dashboard_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_dashboard/manager_filtered_inspections_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_history/manager_batch_qc_history_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_kpi_list/manager_kpi_list_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_nav/manager_nav_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/manager_resolved_alerts/manager_resolved_alerts_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/reports/reports_center_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/user_management_cubit.dart';
import 'package:alwadi_food/presentation/manager/data/repo/manager_dashboard_repo_impl.dart';
import 'package:alwadi_food/presentation/manager/data/repo/manager_kpi_repo_impl.dart';
import 'package:alwadi_food/presentation/manager/domain/repo/manager_dashboard_repo.dart';
import 'package:alwadi_food/presentation/manager/domain/repo/manager_kpi_repo.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/manager_batch/manager_batch_qc_history_ds.dart';
import 'package:alwadi_food/presentation/manager/presentation/views/widgets/reports/reports_center_firestore_ds.dart';
import 'package:alwadi_food/presentation/manager/traceability/cubit/traceability_cubit.dart';
import 'package:alwadi_food/presentation/manager/traceability/data/datasources/traceability_firestore_ds.dart';
import 'package:alwadi_food/presentation/manager/traceability/data/repos/traceability_repository_impl.dart';
import 'package:alwadi_food/presentation/manager/traceability/domain/repos/traceability_repository.dart';
import 'package:alwadi_food/presentation/manager/traceability_v3/data/repositories/traceability_repository_firestore.dart';
import 'package:alwadi_food/presentation/manager/traceability_v3/domain/repositories/traceability_repository.dart';
import 'package:alwadi_food/presentation/manager/traceability_v3/presentation/cubit/traceability_cubit.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/data/repos/production_repository_impl.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_dashboard/qc_dashboard_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_leaderboard/qc_leaderboard_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_reports/qc_reports_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_review/qc_batch_review_cubit.dart';
import 'package:alwadi_food/presentation/qc/data/repos/qc_leaderboard_repository_impl.dart';
import 'package:alwadi_food/presentation/qc/data/repos/qc_reports_repository_impl.dart';
import 'package:alwadi_food/presentation/qc/data/repos/qc_repository_impl.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_leaderboard_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_reports_repository.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:alwadi_food/presentation/settings/cubit/app_settings_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ======================
  // Services
  // ======================
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(
    () => FirebaseFirestore.instance,
  ); // ✅ FirebaseFirestore

  getIt.registerLazySingleton(() => FirebaseAuthService());
  getIt.registerLazySingleton(() => FirestoreService());
  getIt.registerLazySingleton(() => StorageService());
  getIt.registerLazySingleton(() => PreferencesService());

  // ======================
  // Repositories
  // ======================
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<FirebaseAuthService>(),
      getIt<FirestoreService>(),
    ),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<FirestoreService>()),
  );

  getIt.registerLazySingleton<ProductionRepository>(
    () => ProductionRepositoryImpl(
      getIt<FirestoreService>(),
      getIt<StorageService>(),
    ),
  );

  getIt.registerLazySingleton<QCRepository>(
    () => QCRepositoryImpl(getIt<FirestoreService>(), getIt<StorageService>()),
  );

  getIt.registerLazySingleton<QCReportsRepository>(
    () => QCReportsRepositoryImpl(
      getIt<FirestoreService>(),
      getIt<StorageService>(),
      getIt<AuthRepository>(),
      getIt<QCRepository>(),
      getIt<QCPdfReportService>(),
    ),
  );

  getIt.registerLazySingleton<QCLeaderboardRepository>(
    () => QCLeaderboardRepositoryImpl(getIt<QCRepository>()),
  );

  // ======================
  // QC PDF Service
  // ======================
  getIt.registerLazySingleton(() => QCPdfReportService());

  // ======================
  // Cubits
  // ======================

  /// ✅ HomeCubit Singleton
  getIt.registerLazySingleton<HomeCubit>(
    () => HomeCubit(getIt<ProductionRepository>()),
  );

  /// ✅ AuthCubit Factory
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>(), getIt<HomeCubit>()),
  );

  getIt.registerFactory<ProductionCubit>(
    () =>
        ProductionCubit(getIt<ProductionRepository>(), getIt<AuthRepository>()),
  );

  getIt.registerFactory<QCCubit>(
    () => QCCubit(
      getIt<QCRepository>(),
      getIt<ProductionRepository>(),
      getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory(() => QCDashboardCubit(getIt(), getIt()));

  getIt.registerFactory<QCBatchReviewCubit>(
    () => QCBatchReviewCubit(getIt<ProductionRepository>()),
  );

  getIt.registerFactory<AppSettingsCubit>(
    () => AppSettingsCubit(getIt<PreferencesService>()),
  );

  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(getIt<ProductionRepository>(), getIt<QCRepository>()),
  );

  getIt.registerFactory<UserManagementCubit>(
    () => UserManagementCubit(getIt<UserRepository>()),
  );

  getIt.registerFactory(
    () => QCLeaderboardCubit(getIt<QCLeaderboardRepository>()),
  );

  getIt.registerFactory(() => QCReportsCubit(getIt<QCReportsRepository>()));

  // ======================
  // ✅ MANAGER SECTION (VERY IMPORTANT)
  // ======================

  /// ✅ Dashboard Firestore DataSource
  getIt.registerLazySingleton(
    () => ManagerDashboardFirestoreDataSource(getIt<FirebaseFirestore>()),
  );

  /// ✅ KPI List Firestore DataSource (THIS FIXES YOUR ERROR ✅🔥)
  getIt.registerLazySingleton(
    () => ManagerKpiListFirestoreDataSource(getIt<FirebaseFirestore>()),
  );

  /// ✅ Dashboard Repo
  getIt.registerLazySingleton<ManagerDashboardRepo>(
    () =>
        ManagerDashboardRepoImpl(getIt<ManagerDashboardFirestoreDataSource>()),
  );

  /// ✅ KPI Repo
  getIt.registerLazySingleton<ManagerKpiRepo>(
    () => ManagerKpiRepoImpl(getIt<ManagerDashboardFirestoreDataSource>()),
  );

  /// ✅ Dashboard Cubit
  getIt.registerFactory(
    () => ManagerDashboardCubit(getIt<ManagerDashboardRepo>()),
  );

  /// ✅ Bottom Navigation Cubit
  getIt.registerFactory(() => ManagerNavCubit());

  /// ✅ KPI List Cubit
  getIt.registerFactory(
    () => ManagerKpiListCubit(getIt<ManagerKpiListFirestoreDataSource>()),
  );
  // getIt.registerLazySingleton(() => ManagerDashboardFirestoreDataSource(getIt()));
  getIt.registerFactory(() => ManagerFilteredInspectionsCubit(getIt()));
  getIt.registerFactory(() => ManagerActionNeededCubit(getIt()));

  /// ✅ Manager Batch QC History DS
  getIt.registerLazySingleton(
    () => ManagerBatchQcHistoryFirestoreDs(getIt<FirebaseFirestore>()),
  );

  /// ✅ Manager Batch QC History Cubit
  getIt.registerFactory(
    () => ManagerBatchQcHistoryCubit(getIt<ManagerBatchQcHistoryFirestoreDs>()),
  );

  /// ✅ Resolved Alerts Cubit (History)
  getIt.registerFactory(() => ManagerResolvedAlertsCubit(getIt()));

  // ======================
  // ✅ REPORTS CENTER
  // ======================

  // Firestore DS
  getIt.registerLazySingleton(
    () => ReportsCenterFirestoreDataSource(getIt<FirebaseFirestore>()),
  );

  // PDF Service
  getIt.registerLazySingleton(() => ReportsPdfService());

  // Excel Service
  getIt.registerLazySingleton(() => ReportsExcelService());

  // ✅ Reports Center Cubit (هذا المهم)
  getIt.registerFactory<ReportsCenterCubit>(
    () => ReportsCenterCubit(
      getIt<ReportsCenterFirestoreDataSource>(),
      getIt<ReportsPdfService>(),
      getIt<ReportsExcelService>(),
    ),
  );

  // ======================
  // ✅ TRACEABILITY FEATURE
  // ======================
  getIt.registerLazySingleton<TraceabilityV3Repository>(
    () => TraceabilityV3RepositoryFirestore(
      getIt<FirebaseFirestore>(), // 👈 نفس النسخة المسجلة بالأعلى
    ),
  );

  // V3 Cubit
  getIt.registerFactory<TraceabilityCubit>(
    () => TraceabilityCubit(getIt<TraceabilityV3Repository>()),
  );
}
