// import 'package:alwadi_food/core/errors/failures.dart';
// import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
// import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
// import 'package:dart_either/dart_either.dart';

// import '../models/user_model.dart';
// import '../services/firebase_auth_service.dart';
// import '../services/firestore_service.dart';
// import 'package:alwadi_food/core/constants/app_constants.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   final FirebaseAuthService authService;
//   final FirestoreService firestore;

//   AuthRepositoryImpl(this.authService, this.firestore);
//   //signIn
//   @override
//   Future<Either<Failure, UserEntity>> signIn(
//     String email,
//     String password,
//   ) async {
//     try {
//       // repo --> FirebaseAuthService in signIn
//       // credential it contains user info from firebase like uid,email etc

//       final credential = await authService.signIn(
//         email: email,
//         password: password,
//       );

//       // After signIn , we attempt to retrive user data from firestore
//       final doc = await firestore.getDocument(
//         // name of collection
//         AppConstants.usersCollection,
//         // the users document key
//         credential.user!.uid,
//       );
//       // Verify the existence of the document (if not exist return failure)
//       if (!doc.exists) {
//         return Left(ServerFailure(message: 'User document does not exist'));
//       }
//       // if the document exists, we convert it from JSON to UserModel (which extends UserEntity)
//       return Right(UserModel.fromJson(doc.data() as Map<String, dynamic>));
//     } catch (e) {
//       return Left(ServerFailure(message: "Something went wrong"));
//     }
//   }

//   // signUp
//   @override
//   Future<Either<Failure, UserEntity>> signUp(
//     String name,
//     String email,
//     String password,
//     String role,
//   ) async {
//     try {
//       // repo --> FirebaseAuthService in signup
//       // credential it contains user info from firebase like uid,email  etc

//       final credential = await authService.signUp(
//         email: email,
//         password: password,
//       );
//       // we take the unique users ID (uid) provided by firebae
//       // This is important because it will be the primary user key in the Firestore database
//       final uid = credential.user!.uid;
//       // Create a new UserModel instance to represent the newly registered user
//       final normalizedRole = role.trim().toLowerCase();
//       final user = UserModel(
//         uid: uid,
//         name: name,
//         email: email,
//         role: normalizedRole,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       );
//       // we go to firestore and create a new document within the useresCollection

//       await firestore.createDocument(
//         AppConstants.usersCollection,
//         // document key
//         uid,
//         // user.toJson() converts the user object into a Map<String, dynamic> for storage in Firestore
//         user.toJson(),
//       );
//       // progess successfuly return the user entity
//       return Right(user);
//     } catch (e) {
//       return Left(ServerFailure(message: "Something went wrong"));
//     }
//   }

//   // signOut
//   @override
//   Future<Either<Failure, void>> signOut() async {
//     try {
//       // repo --> FirebaseAuthService in signOut

//       await authService.signOut();
//       return const Right(null);
//     } catch (e) {
//       return Left(ServerFailure(message: "Something went wrong"));
//     }
//   }

//   // getCurrentUser
//   @override
//   Future<Either<Failure, UserEntity?>> getCurrentUser() async {
//     try {
//       // here verify if there current user who is in firebase auth
//       final firebaseUser = authService.currentUser;
//       // if ther is no registered user, firebaseUser will be null (we return Right(null))
//       if (firebaseUser == null) return const Right(null);
//       // we retrive the user document from firestore using the users
//       // Here we access the database to obtain all the information related to the user
//       final doc = await firestore.getDocument(
//         AppConstants.usersCollection,
//         firebaseUser.uid,
//       );
//       // If we don't find the document in Firestore, we also return null
//       if (!doc.exists) return const Right(null);
//       // If the document exists, we convert it from JSON to UserModel and return it
//       return Right(UserModel.fromJson(doc.data() as Map<String, dynamic>));
//     } catch (e) {
//       return Left(ServerFailure(message: "Something went wrong"));
//     }
//   }

//   // authStateChanges
//   @override
//   Stream<UserEntity?> authStateChanges() {
//     // Listen to authentication state changes from FirebaseAuthService
//     return authService.authStateChanges().asyncMap((firebaseUser) async {
//       // If there is no authenticated user, return null
//       if (firebaseUser == null) return null;

//       // Retrieve the user document from Firestore using the user's UID
//       // Access the database to get all information related to the user
//       final doc = await firestore.getDocument(
//         AppConstants.usersCollection,
//         firebaseUser.uid,
//       );
//       // If the document does not exist in Firestore, return null
//       if (!doc.exists) return null;
//       // If the document exists, convert it from JSON to UserModel and return it
//       return UserModel.fromJson(doc.data() as Map<String, dynamic>);
//     });
//   }

//   // getCurrentUserId
//   @override
//   String? getCurrentUserId() {
//     // Directly retrieve the current user's UID from FirebaseAuthService
//     // This method provides a quick way to access the user's unique identifier
//     return authService.currentUser?.uid;
//   }
// }
import 'package:alwadi_food/core/errors/failures.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:dart_either/dart_either.dart';

import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService authService;
  final FirestoreService firestore;

  AuthRepositoryImpl(this.authService, this.firestore);

  // ================= SIGN UP =================
  @override
  Future<Either<Failure, UserEntity>> signUp(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      final credential = await authService.signUp(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      final normalizedRole = role.trim().toLowerCase();

      final user = UserModel(
        uid: uid,
        name: name,
        email: email,
        role: normalizedRole,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await firestore.createDocument(
        AppConstants.usersCollection,
        uid,
        user.toJson(),
      );

      return Right(user);
    } catch (e, s) {
      // 🔥 مهم للتشخيص
      // ignore: avoid_print
      print('SIGNUP ERROR => $e');
      // ignore: avoid_print
      print('STACK => $s');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ================= SIGN IN =================
  @override
  Future<Either<Failure, UserEntity>> signIn(
    String email,
    String password,
  ) async {
    try {
      final credential = await authService.signIn(
        email: email,
        password: password,
      );

      final doc = await firestore.getDocument(
        AppConstants.usersCollection,
        credential.user!.uid,
      );

      if (!doc.exists) {
        return Left(ServerFailure(message: 'User document does not exist'));
      }

      return Right(UserModel.fromJson(doc.data() as Map<String, dynamic>));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ================= SIGN OUT =================
  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authService.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ================= CURRENT USER =================
  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final firebaseUser = authService.currentUser;
      if (firebaseUser == null) return const Right(null);

      final doc = await firestore.getDocument(
        AppConstants.usersCollection,
        firebaseUser.uid,
      );

      if (!doc.exists) return const Right(null);

      return Right(UserModel.fromJson(doc.data() as Map<String, dynamic>));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ================= AUTH STATE =================
  @override
  Stream<UserEntity?> authStateChanges() {
    return authService.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      final doc = await firestore.getDocument(
        AppConstants.usersCollection,
        firebaseUser.uid,
      );

      if (!doc.exists) return null;

      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    });
  }

  @override
  String? getCurrentUserId() {
    return authService.currentUser?.uid;
  }
}
