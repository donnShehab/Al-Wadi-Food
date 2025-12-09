
// import 'package:alwadi_food/core/errors/failures.dart';
// import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
// import 'package:alwadi_food/presentation/auth/domain/repos/user_repository.dart';
// import 'package:dart_either/dart_either.dart';

// import '../models/user_model.dart';
// import '../services/firestore_service.dart';
// import 'package:alwadi_food/core/constants/app_constants.dart';

// class UserRepositoryImpl implements UserRepository {
//   final FirestoreService firestore;

//   UserRepositoryImpl(this.firestore);

//   @override
//   Future<Either<Failure, UserEntity>> getUserById(String uid) async {
//     try {
//       final doc = await firestore.getDocument(
//         AppConstants.usersCollection,
//         uid,
//       );

//       if (!doc.exists) return Left(ServerFailure(message:"User not found"));

//       return Right(UserModel.fromJson(doc.data() as Map<String, dynamic>));
//     } catch (e) {
//       return Left(ServerFailure(message:e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, List<UserEntity>>> getAllUsers() async {
//     try {
//       final snapshot = await firestore
//           .collection(AppConstants.usersCollection)
//           .get();

//       final users = snapshot.docs
//           .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>))
//           .toList();

//       return Right(users);
//     } catch (e) {
//       return Left(ServerFailure(message:e.toString()));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> updateUser(
//     String uid,
//     Map<String, dynamic> data,
//   ) async {
//     try {
//       await firestore.updateDocument(AppConstants.usersCollection, uid, data);
//       return const Right(null);
//     } catch (e) {
//       return Left(ServerFailure(message: e.toString()));
//     }
//   }
// }

import 'package:alwadi_food/core/constants/app_constants.dart';
import 'package:alwadi_food/core/errors/failures.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/user_repository.dart';
import 'package:dart_either/dart_either.dart';

import '../models/user_model.dart';
import '../services/firestore_service.dart';

class UserRepositoryImpl implements UserRepository {
  final FirestoreService firestore;

  UserRepositoryImpl(this.firestore);

  // -------------------------------------------------------------
  // Get User by ID
  // -------------------------------------------------------------
  @override
  Future<Either<Failure, UserEntity>> getUserById(String uid) async {
    try {
      final doc = await firestore.getDocument(
        AppConstants.usersCollection,
        uid,
      );

      if (!doc.exists) {
        return Left(ServerFailure(message: "User not found"));
      }

      return Right(UserModel.fromJson(doc.data() as Map<String, dynamic>));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // -------------------------------------------------------------
  // Get All Users
  // -------------------------------------------------------------
  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsersEither() async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.usersCollection)
          .get();

      final users = snapshot.docs
          .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>))
          .toList();

      return Right(users);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // -------------------------------------------------------------
  // Create User
  // -------------------------------------------------------------
  @override
  Future<Either<Failure, void>> createUserEither(UserEntity user) async {
    try {
      final json = UserModel.fromEntity(user).toJson();

      await firestore.setDocument(AppConstants.usersCollection, user.uid, json);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // -------------------------------------------------------------
  // Update User
  // -------------------------------------------------------------
  @override
  Future<Either<Failure, void>> updateUserEither(UserEntity user) async {
    try {
      final json = UserModel.fromEntity(user).toJson();

      await firestore.updateDocument(
        AppConstants.usersCollection,
        user.uid,
        json,
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // ----------------------------------------------------------------------
  // ملاحظة: إن كانت الواجهة UserRepository تحتوي الدوال القديمة،
  // نتركها لمنع كسر الـ Interface
  // ----------------------------------------------------------------------

  @override
  Future<Either<Failure, List<UserEntity>>> getAllUsers() {
    return getAllUsersEither();
  }

  @override
  Future<Either<Failure, void>> updateUser(
    String uid,
    Map<String, dynamic> data,
  ) async {
    try {
      await firestore.updateDocument(AppConstants.usersCollection, uid, data);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
