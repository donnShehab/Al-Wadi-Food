import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:equatable/equatable.dart';

sealed class UserManagementState extends Equatable {
  const UserManagementState();

  @override
  List<Object?> get props => [];
}

class UserManagementInitial extends UserManagementState {
  const UserManagementInitial();
}

class UserManagementLoading extends UserManagementState {
  const UserManagementLoading();
}

class UserManagementLoaded extends UserManagementState {
  final List<UserEntity> users;

  const UserManagementLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserManagementSuccess extends UserManagementState {
  final String message;

  const UserManagementSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UserManagementError extends UserManagementState {
  final String message;

  const UserManagementError(this.message);

  @override
  List<Object?> get props => [message];
}
