import 'package:alwadi_food/core/errors/failures.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:dart_either/dart_either.dart';

abstract class AuthRepository {
  // signIn
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
// signup
  Future<Either<Failure, UserEntity>> signUp(
    String name,
    String email,
    String password,
    String role,
  );
// signOut
  Future<Either<Failure, void>> signOut();
// getCurrentUser
  Future<Either<Failure, UserEntity>> getCurrentUser();
// authStateChanges
  Stream<UserEntity?> authStateChanges();
// getCurrenUserId
  String? getCurrentUserId();
}
