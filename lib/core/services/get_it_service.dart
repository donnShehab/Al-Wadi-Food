// import 'package:alwadi_food/core/services/database_service.dart';
// import 'package:alwadi_food/core/services/firebase_auth_service.dart';
// import 'package:alwadi_food/core/services/firestore_service.dart';
// import 'package:alwadi_food/feature/auth/data/repos/auth_repo_impl.dart';
// import 'package:alwadi_food/feature/auth/domain/repos/auth_repo.dart';
// import 'package:get_it/get_it.dart';

// final getIt = GetIt.instance;

// void setupGetIt() {
//   print("Registering services...");
//   // 1.نسل الخدمة بالاول 
// //   getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  
// // // 2.نسجل repo
// //   //Type class
// //   getIt.registerSingleton<AuthRepo>(
// //     // النسخه ل بنوفرها
// //     AuthRepoImpl(firebaseAuthService: getIt<FirebaseAuthService>()),
// //   );

// getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
// getIt.registerLazySingleton<DatabaseService>(() => FirestoreService());

//   getIt.registerLazySingleton<AuthRepo>(
//     () => AuthRepoImpl(
      
//       firebaseAuthService: getIt<FirebaseAuthService>(),
//       databaseService: getIt<DatabaseService>(),
//       ),
//   );

// }
