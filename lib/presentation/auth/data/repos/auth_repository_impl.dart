
import 'package:alwadi_food/core/errors/failures.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:dart_either/dart_either.dart';

import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_service.dart';
import 'package:alwadi_food/core/constants/app_constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService authService;
  final FirestoreService firestore;

  AuthRepositoryImpl(this.authService, this.firestore);

  @override
  Future<Either<Failure, UserEntity>> signIn(
    String email,
    String password,
  ) async {
    try {
      final credential = await authService.signIn(email, password);

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

  @override
  Future<Either<Failure, UserEntity>> signUp(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      final credential = await authService.signUp(email, password);

      final uid = credential.user!.uid;

      final user = UserModel(
        uid: uid,
        name: name,
        email: email,
        role: role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await firestore.createDocument(
        AppConstants.usersCollection,
        uid,
        user.toJson(),
      );

      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authService.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message:  e.toString()));
    }
  }

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
      return Left(ServerFailure(message:e.toString()));
    }
  }

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
