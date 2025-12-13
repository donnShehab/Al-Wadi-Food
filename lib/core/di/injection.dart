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
import 'package:alwadi_food/presentation/qc/data/repos/qc_repository_impl.dart';
import 'package:alwadi_food/presentation/qc/domain/repos/qc_repository.dart';
import 'package:alwadi_food/presentation/settings/cubit/app_settings_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
Future<void> setupDependencies() async {
  // Services
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseAuthService());
  getIt.registerLazySingleton(() => FirestoreService());
  getIt.registerLazySingleton(() => StorageService());
  getIt.registerLazySingleton(() => PreferencesService());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt(),
      getIt(),
    ), // يستخدم FirebaseAuthService و FirestoreService
  );
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<ProductionRepository>(
    () => ProductionRepositoryImpl(getIt(), getIt()),
  );
  getIt.registerLazySingleton<QCRepository>(
    () => QCRepositoryImpl(getIt(), getIt()),
  );

  // Cubits
  getIt.registerFactory(() => AuthCubit(getIt()));
  getIt.registerFactory(() => HomeCubit(getIt(),));
  getIt.registerFactory(() => ProductionCubit(getIt(), getIt()));
  getIt.registerFactory(() => QCCubit(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => AppSettingsCubit(getIt()));
  getIt.registerFactory(() => DashboardCubit(getIt(), getIt()));
  getIt.registerFactory(() => UserManagementCubit(getIt()));
  getIt.registerFactory(() => TraceabilityCubit(getIt(), getIt()));
}
