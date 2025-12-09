import 'package:alwadi_food/presentation/auth/domain/repos/auth_repository.dart';
import 'package:alwadi_food/presentation/home/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepository;

  HomeCubit(this._authRepository) : super(const HomeInitial());

  Future<void> loadUser() async {
    emit(const HomeLoading());

    final result = await _authRepository.getCurrentUser();

    result.fold(
      ifLeft: (failure) => emit(HomeError(failure.message)),
      ifRight: (user) {
        if (user == null) {
          emit(const HomeError("User not found"));
        } else {
          emit(HomeLoaded(user));
        }
      },
    );
  }
}
