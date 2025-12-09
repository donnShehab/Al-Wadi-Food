

import 'package:alwadi_food/core/errors/failures.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:dart_either/dart_either.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);

  Future<Either<Failure, UserEntity>> signUp(
    String name,
    String email,
    String password,
    String role,
  );

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Stream<UserEntity?> authStateChanges();

  String? getCurrentUserId();
}
