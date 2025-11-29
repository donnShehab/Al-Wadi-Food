import 'package:alwadi_food/core/errors/failures.dart';
import 'package:alwadi_food/feature/auth/domain/entites/user_entity.dart';
import 'package:dart_either/dart_either.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phoneNumber,
  );
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity>> signInWithGoogle();
}
