import 'package:alwadi_food/core/services/preferences_service.dart';
import 'package:alwadi_food/presentation/auth/cubit/auth_cubit.dart';
import 'package:alwadi_food/presentation/auth/data/repos/auth_repository_impl.dart';
import 'package:alwadi_food/presentation/auth/data/repos/user_repository_impl.dart';
import 'package:alwadi_food/presentation/auth/data/services/firebase_auth_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/firestore_service.dart';
import 'package:alwadi_food/presentation/auth/data/services/storage_service.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/user_repository.dart';
import 'package:alwadi_food/presentation/home/cubit/home_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/dashboard_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/traceability_cubit.dart';
import 'package:alwadi_food/presentation/manager/cubit/user_management_cubit.dart';
import 'package:alwadi_food/presentation/production/cubit/production_cubit.dart';
import 'package:alwadi_food/presentation/production/data/repos/production_repository_impl.dart';
import 'package:alwadi_food/presentation/production/domain/repos/production_repository.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_dashboard/qc_dashboard_cubit.dart';
import 'package:alwadi_food/presentation/qc/cubit/qc_review/qc_batch_review_cubit.dart';
import 'package:alwadi_food/presentation/qc/data/repos/qc_repository_impl.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:alwadi_food/presentation/settings/cubit/app_settings_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ======================
  // Services
  // ======================
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
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

  // ======================
  // Cubits
  // ======================

  // 🔴 HomeCubit = Singleton (المهم)
  getIt.registerLazySingleton<HomeCubit>(
    () => HomeCubit(getIt<ProductionRepository>()),
  );

  // AuthCubit = Factory (طبيعي)
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      getIt<AuthRepository>(),
      getIt<HomeCubit>(), // 👈 نفس الـ HomeCubit دائمًا
    ),
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

  // QC Dashboard Cubit
  getIt.registerFactory(() => QCDashboardCubit(getIt(), getIt()));
  // qc review
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

  getIt.registerFactory<TraceabilityCubit>(
    () =>
        TraceabilityCubit(getIt<ProductionRepository>(), getIt<QCRepository>()),
  );
}
