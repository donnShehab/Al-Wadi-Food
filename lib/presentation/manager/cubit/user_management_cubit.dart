import 'package:alwadi_food/presentation/auth/domain/entites/user_entity.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/user_repository.dart';
import 'package:alwadi_food/presentation/manager/cubit/user_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserManagementCubit extends Cubit<UserManagementState> {
  final UserRepository _userRepository;

  UserManagementCubit(this._userRepository)
      : super(const UserManagementInitial());

  Future<void> loadUsers() async {
    emit(const UserManagementLoading());

    final result = await _userRepository.getAllUsersEither(); // <-- new

    result.fold(
      ifLeft:
      (failure) => emit(UserManagementError(failure.message)),
      ifRight:
      (users) => emit(UserManagementLoaded(users)),
    );
  }

  Future<void> createUser(UserEntity user) async {
    emit(const UserManagementLoading());

    final result = await _userRepository.createUserEither(user); // <-- new

    result.fold(
      ifLeft:
      (failure) => emit(UserManagementError(failure.message)),
      ifRight:
      (_) => emit(const UserManagementSuccess("User created successfully")),
    );

    await loadUsers();
  }

  Future<void> updateUser(UserEntity user) async {
    emit(const UserManagementLoading());

    final result = await _userRepository.updateUserEither(user); // <-- new

    result.fold(
      ifLeft:
      (failure) => emit(UserManagementError(failure.message)),
      ifRight:
      (_) => emit(const UserManagementSuccess("User updated successfully")),
    );

    await loadUsers();
  }

  Future<void> toggleUserStatus(UserEntity user) async {
    emit(const UserManagementLoading());

    final updated = user.copyWith(
      isActive: !user.isActive,
      updatedAt: DateTime.now(),
    );

    final result = await _userRepository.updateUserEither(updated);

    result.fold(
      ifLeft:
      (failure) => emit(UserManagementError(failure.message)),
      ifRight:
      (_) => emit(
        UserManagementSuccess(
          user.isActive ? "User disabled" : "User enabled",
        ),
      ),
    );

    await loadUsers();
  }
}
