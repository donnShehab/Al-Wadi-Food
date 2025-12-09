
import 'package:alwadi_food/core/errors/failures.dart';
import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:dart_either/dart_either.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUserById(String uid);

  Future<Either<Failure, List<UserEntity>>> getAllUsers();

  Future<Either<Failure, void>> updateUser(
    String uid,
    Map<String, dynamic> data,
  );
  Future<Either<Failure, List<UserEntity>>> getAllUsersEither();
Future<Either<Failure, void>> createUserEither(UserEntity user);
Future<Either<Failure, void>> updateUserEither(UserEntity user);

}
