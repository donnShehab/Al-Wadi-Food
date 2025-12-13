import 'package:alwadi_food/presentation/auth/cubit/auth_State.dart';
import 'package:alwadi_food/presentation/home/cubit/home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
    final HomeCubit homeCubit;

  AuthCubit(this.authRepository, this.homeCubit) : super(AuthLoading()); // 👈 مهم

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    final result = await authRepository.getCurrentUser();

    result.fold(
      ifLeft: (failure) => emit(AuthUnauthenticated()),
      ifRight: (user) {
        if (user == null) {
          emit(AuthUnauthenticated());
        } else {
            homeCubit.loadStats(); // 🔥 preload هنا (المكان الصحيح)
          emit(AuthSuccess(user: user));
        }
      },
    );
  }



  /// Login
  Future<void> signIn({required String email,required String password}) async {
    emit(AuthLoading());

    final result = await authRepository.signIn(email, password);

    result.fold(
      ifLeft: (failure) => emit(AuthFailure(message: failure.message)),
ifRight: (user) {
        homeCubit.loadStats(); // 🔥 preload
        emit(AuthSuccess(user: user));
      },    );
  }

  /// Register new user
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    emit(AuthLoading());

    final result = await authRepository.signUp(name, email, password, role);

    result.fold(
      ifLeft: (failure) => emit(AuthFailure(message: failure.message)),
      ifRight: (user) => emit(AuthSuccess(user: user)),
    );
  }

  /// Logout
  Future<void> signOut() async {
    emit(AuthLoading());

    final result = await authRepository.signOut();

    result.fold(
      ifLeft: (failure) => emit(AuthFailure(message: failure.message)),
      ifRight: (_) => emit(AuthInitial()),
    );
  }

  /// Get current user from cache or firebase
  Future<void> getCurrentUser() async {
    emit(AuthLoading());

    final result = await authRepository.getCurrentUser();

    result.fold(
      ifLeft: (failure) => emit(AuthFailure(message: failure.message)),
      ifRight: (user) {
        if (user == null) {
          emit(AuthInitial());
        } else {
          emit(AuthSuccess(user: user));
        }
      },
    );
  }
}
