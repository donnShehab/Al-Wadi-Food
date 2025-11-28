import 'package:alwadi_food/core/errors/exceptions.dart';
import 'package:alwadi_food/core/errors/failures.dart';
import 'package:alwadi_food/core/services/firebase_auth_service.dart';
import 'package:alwadi_food/feature/auth/data/models/user_model.dart';
import 'package:alwadi_food/feature/auth/domain/entites/user_entity.dart';
import 'package:alwadi_food/feature/auth/domain/repos/auth_repo.dart';
import 'package:dart_either/src/dart_either.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl implements AuthRepo {
  final FirebaseAuthService firebaseAuthService;

  AuthRepoImpl({required this.firebaseAuthService});
  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phoneNumber,
  ) async {
    try {
      var user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(UserModel.fromFirebaseUser(user));
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      var user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(UserModel.fromFirebaseUser(user));
    } on CustomException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
