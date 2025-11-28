import 'package:alwadi_food/feature/auth/domain/entites/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.email,
    required super.name,
    required super.phoneNumber,
    required super.uId,
  });
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      email: user.email ?? '',
      name: user.displayName ?? '',
      phoneNumber: user.phoneNumber ?? '',
      uId: user.uid,
    );
  }
}
